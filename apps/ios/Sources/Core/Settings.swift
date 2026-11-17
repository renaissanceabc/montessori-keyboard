import Foundation

/// What sits in the strip above the tiles.
public enum StripMode: String, Codable, CaseIterable, Sendable {
    /// Rhyming words to swap in for the word just typed.
    case rhymes
    /// The word just typed, one tile per letter. Tap a letter, then a tile, to change it.
    case letters
    /// Nothing. Just the tiles.
    case off
}

/// Every choice a grown-up makes in the app. The app writes it; the keyboard reads it.
public struct KeyboardSettings: Codable, Equatable, Sendable {
    public var order: KeyOrder = .abc
    public var cursive = false
    public var capitalsWithShift = false
    public var phonograms = true
    public var strip: StripMode = .rhymes
    public var numbers: NumberStyle = .beads
    public var letterSounds = true
    public var keyClicks = true

    public init() {}

    /// Decodes leniently, so a setting added later never wipes the ones already saved.
    public init(from decoder: any Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        let d = KeyboardSettings()
        order = (try? c.decode(KeyOrder.self, forKey: .order)) ?? d.order
        cursive = (try? c.decode(Bool.self, forKey: .cursive)) ?? d.cursive
        capitalsWithShift = (try? c.decode(Bool.self, forKey: .capitalsWithShift)) ?? d.capitalsWithShift
        phonograms = (try? c.decode(Bool.self, forKey: .phonograms)) ?? d.phonograms
        strip = (try? c.decode(StripMode.self, forKey: .strip)) ?? d.strip
        numbers = (try? c.decode(NumberStyle.self, forKey: .numbers)) ?? d.numbers
        letterSounds = (try? c.decode(Bool.self, forKey: .letterSounds)) ?? d.letterSounds
        keyClicks = (try? c.decode(Bool.self, forKey: .keyClicks)) ?? d.keyClicks
    }
}
