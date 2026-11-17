import MontessoriCore
import Observation
import SwiftUI

/// What the keyboard does to the text it types into. The extension wires these to its text document proxy;
/// the app's preview and Pad wire them to a string.
@MainActor
public struct KeyboardHost {
    public var insert: (String) -> Void
    public var deleteBackward: () -> Void
    /// The text just before the cursor (the proxy only gives a few words; that's all the strip needs).
    public var textBeforeCursor: () -> String
    /// Set only when the system wants the keyboard to show its own globe key.
    public var nextKeyboard: (() -> Void)?
    /// A key click, through whatever the host is allowed to play.
    public var click: () -> Void
    /// Whether speech may play (a keyboard needs Full Access for it).
    public var canSpeak: Bool

    public init(
        insert: @escaping (String) -> Void,
        deleteBackward: @escaping () -> Void,
        textBeforeCursor: @escaping () -> String,
        nextKeyboard: (() -> Void)? = nil,
        click: @escaping () -> Void = {},
        canSpeak: Bool = true
    ) {
        self.insert = insert
        self.deleteBackward = deleteBackward
        self.textBeforeCursor = textBeforeCursor
        self.nextKeyboard = nextKeyboard
        self.click = click
        self.canSpeak = canSpeak
    }

    /// A host that types into a string binding, for the app's preview and Pad.
    public static func text(_ text: Binding<String>, click: @escaping () -> Void = {}) -> KeyboardHost {
        KeyboardHost(
            insert: { text.wrappedValue += $0 },
            deleteBackward: { if !text.wrappedValue.isEmpty { text.wrappedValue.removeLast() } },
            textBeforeCursor: { text.wrappedValue },
            click: click
        )
    }
}

public enum KeyLayer: Sendable {
    case letters
    case numbers
}

/// The keyboard's state: which layer, shift, the phonogram tray and the strip. Views read it; taps go through it.
@MainActor
@Observable
public final class KeyboardModel {
    public var settings: KeyboardSettings {
        didSet { if !settings.capitalsWithShift { shifted = false } }
    }
    @ObservationIgnored public var host: KeyboardHost
    public private(set) var layer: KeyLayer = .letters
    public private(set) var shifted = false
    /// The letter whose phonograms are showing, if the popup is open (capitalized when shift was on).
    public private(set) var trayLetter: Character?
    /// The tile the popup grew from, so it can sit above it.
    public private(set) var trayKey: Character?
    /// The team under the finger while it slides across the popup.
    public private(set) var highlightedTeam: Int?
    /// In the letters strip, the tile picked to be changed by the next letter typed.
    public private(set) var selectedLetter: Int?
    /// The word before the cursor, refreshed after every key and whenever the host's text changes.
    public private(set) var trailing: TrailingWord?

    @ObservationIgnored private let speech = LetterSpeech()

    public init(settings: KeyboardSettings, host: KeyboardHost) {
        self.settings = settings
        self.host = host
        refresh()
    }

    // MARK: What the strip shows

    public var rhymes: [String] {
        guard let trailing else { return [] }
        return WordFamilies.rhymes(for: trailing.word)
    }

    public var family: String? {
        trailing.flatMap { WordFamilies.family(of: $0.word) }
    }

    public var trayTeams: [String] {
        trayLetter.map(Phonograms.teams(for:)) ?? []
    }

    /// Re-reads the text before the cursor. Call when the host's text changes from outside the keyboard.
    public func refresh() {
        trailing = TrailingWord(before: host.textBeforeCursor())
        if let selected = selectedLetter, selected >= (trailing?.word.count ?? 0) { selectedLetter = nil }
    }

    // MARK: Keys

    /// The label a letter tile shows right now.
    public func label(for letter: Character) -> String {
        shifted ? letter.uppercased() : String(letter)
    }

    public func tap(letter: Character) {
        let typed = label(for: letter)
        host.click()
        if let index = selectedLetter, let trailing {
            replaceLetter(at: index, in: trailing, with: typed)
        } else {
            host.insert(typed)
        }
        say(typed)
        shifted = false
        closeTray()
        refresh()
    }

    /// Holding a tile opens its phonograms above it, when that's on and the letter has any.
    public func hold(letter: Character) {
        guard settings.phonograms, layer == .letters else { return }
        let key = Character(label(for: letter))
        guard !Phonograms.teams(for: key).isEmpty else { return }
        trayLetter = key
        trayKey = letter
        highlightedTeam = nil
        say(String(key))
    }

    /// The finger slid onto a team in the popup (or off them all).
    public func highlight(team index: Int?) {
        guard trayLetter != nil, index != highlightedTeam else { return }
        highlightedTeam = index.flatMap { trayTeams.indices.contains($0) ? $0 : nil }
    }

    /// The finger lifted after a hold: type the team under it, or leave the popup open to tap.
    public func releaseHold() {
        guard let index = highlightedTeam, trayTeams.indices.contains(index) else {
            highlightedTeam = nil
            return
        }
        tap(team: trayTeams[index])
    }

    public func tap(team: String) {
        host.click()
        host.insert(team)
        say(team)
        closeTray()
        shifted = false
        refresh()
    }

    public func closeTray() {
        trayLetter = nil
        trayKey = nil
        highlightedTeam = nil
    }

    public func tapShift() {
        host.click()
        closeTray()
        guard settings.capitalsWithShift else { return }
        shifted.toggle()
    }

    public func tapDelete() {
        host.click()
        closeTray()
        host.deleteBackward()
        refresh()
    }

    public func tapSpace() {
        host.click()
        closeTray()
        host.insert(" ")
        selectedLetter = nil
        refresh()
    }

    public func tapReturn() {
        host.click()
        closeTray()
        host.insert("\n")
        selectedLetter = nil
        refresh()
    }

    public func toggleLayer() {
        host.click()
        layer = layer == .letters ? .numbers : .letters
        closeTray()
        shifted = false
    }

    /// Digits and punctuation on the 123 layer.
    public func tap(symbol: String) {
        host.click()
        host.insert(symbol)
        if let digit = Int(symbol) { say(NumberWords.spell(digit), ipa: false) }
        refresh()
    }

    // MARK: Strip

    /// Swaps the word before the cursor for a rhyme, keeping its spaces and its capital.
    public func swap(to rhyme: String) {
        guard let trailing else { return }
        host.click()
        for _ in 0..<trailing.deleteCount { host.deleteBackward() }
        let word = trailing.word.first?.isUppercase == true ? rhyme.prefix(1).uppercased() + rhyme.dropFirst() : rhyme
        host.insert(word + String(repeating: " ", count: trailing.trailingSpaces))
        say(word, ipa: false)
        refresh()
    }

    /// Picks a letter in the strip's word; the next letter tile replaces it. Tapping it again lets go.
    public func select(letterAt index: Int) {
        host.click()
        selectedLetter = selectedLetter == index ? nil : index
    }

    private func replaceLetter(at index: Int, in trailing: TrailingWord, with typed: String) {
        let letters = Array(trailing.word)
        guard letters.indices.contains(index) else { return }
        let after = String(letters[(index + 1)...])
        for _ in 0..<(letters.count - index + trailing.trailingSpaces) { host.deleteBackward() }
        host.insert(typed + after + String(repeating: " ", count: trailing.trailingSpaces))
        selectedLetter = nil
    }

    // MARK: Sound

    private func say(_ text: String, ipa: Bool = true) {
        guard settings.letterSounds, host.canSpeak else { return }
        speech.say(text, useIPA: ipa)
    }
}
