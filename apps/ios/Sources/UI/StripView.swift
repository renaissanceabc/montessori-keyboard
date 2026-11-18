import MontessoriCore
import SwiftUI

/// A word drawn in tile colors: blue vowels, red consonants.
struct ColoredWord: View {
    var word: String
    var size: CGFloat
    var cursive: Bool
    @Environment(\.palette) private var palette

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(word.enumerated()), id: \.offset) { _, ch in
                Text(String(ch)).foregroundStyle(palette.color(for: LetterKind(ch)))
            }
        }
        .font(TileFont.tile(size: size, cursive: cursive))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(word)
    }
}

/// A small tile in the strip: a rhyme, or one letter of the word being changed.
struct Chip: View {
    var text: String
    var cursive: Bool
    var selected = false
    /// A letter of the word mat: a fixed 26×32 tile.
    var letter = false
    var onTap: () -> Void

    var body: some View {
        // A plain Button, not KeyButton, so the strip's horizontal scroll still works.
        Button(action: onTap) {
            ColoredWord(word: text, size: 19, cursive: cursive)
                .padding(.horizontal, letter ? 0 : 9)
                .padding(.bottom, letter ? 2 : 3)
                .frame(width: letter ? 26 : nil)
        }
        .buttonStyle(ChipStyle(selected: selected, cornerRadius: letter ? 5 : 7))
        .accessibilityLabel(text)
        .accessibilityAddTraits(selected ? .isSelected : [])
    }
}

/// A strip chip, as the canvas's Strip board draws it: flat paper on a 1pt edge in maple, a small tile in walnut.
/// The chosen letter gets a blue ring outside it and stays up.
struct ChipStyle: ButtonStyle {
    var selected: Bool
    var cornerRadius: CGFloat
    @Environment(\.palette) private var palette

    func makeBody(configuration: Configuration) -> some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        let pressed = configuration.isPressed
        configuration.label
            .frame(maxHeight: .infinity)
            .background(
                shape.fill(
                    LinearGradient(colors: [palette.chipTop, palette.chipBottom], startPoint: .top, endPoint: .bottom))
            )
            .background(shape.fill(palette.tileEdge).offset(y: pressed ? 0 : palette.chipDepth))
            .offset(y: pressed ? palette.chipDepth : 0)
            .fixedSize(horizontal: true, vertical: false)
            .frame(height: 32)
            .overlay {
                if selected {
                    shape.inset(by: -2).stroke(palette.vowel, lineWidth: 2)
                }
            }
            .animation(pressed ? nil : .easeOut(duration: 0.08), value: pressed)
    }
}

/// One rhyme in the strip: the word in tile colors, filling its third of the strip.
/// It has no chip; pressing it shows a soft paper patch behind the word.
struct RhymeSlot: View {
    var word: String
    var cursive: Bool
    var onTap: () -> Void

    var body: some View {
        // A plain Button, not KeyButton, as with the chips.
        Button(action: onTap) {
            ColoredWord(word: word, size: 21, cursive: cursive)
                .padding(.bottom, 3)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
        }
        .buttonStyle(RhymeSlotStyle())
        .accessibilityLabel(word)
    }
}

struct RhymeSlotStyle: ButtonStyle {
    @Environment(\.palette) private var palette

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .fill(palette.chipTop)
                    .padding(.vertical, 6)
                    .padding(.horizontal, 4)
                    .opacity(configuration.isPressed ? 1 : 0)
            )
            .animation(configuration.isPressed ? nil : .easeOut(duration: 0.08), value: configuration.isPressed)
    }
}

/// The strip above the tiles.
struct StripView: View {
    @Bindable var model: KeyboardModel
    @Environment(\.palette) private var palette

    var body: some View {
        Group {
            switch model.settings.strip {
            case .rhymes: rhymes
            case .letters: letters
            case .off: Color.clear
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 44)
    }

    /// Three rhymes in three equal slots, like the system suggestion bar. With none, the strip is blank.
    @ViewBuilder private var rhymes: some View {
        let words = model.rhymes
        if !words.isEmpty {
            HStack(spacing: 0) {
                ForEach(0..<KeyboardModel.rhymeSlots, id: \.self) { index in
                    if index > 0, index < words.count {
                        Rectangle().fill(palette.stripLine).frame(width: 1, height: 24)
                    }
                    if index < words.count {
                        RhymeSlot(word: words[index], cursive: model.settings.cursive) {
                            model.swap(to: words[index])
                        }
                    } else {
                        Color.clear.frame(maxWidth: .infinity)
                    }
                }
            }
            .padding(.horizontal, 8)
            .accessibilityElement(children: .contain)
            .accessibilityLabel(model.family.map { "Rhymes with \($0)" } ?? "Rhymes")
        }
    }

    @ViewBuilder private var letters: some View {
        if let word = model.trailing?.word {
            HStack(spacing: 6) {
                ForEach(Array(word.enumerated()), id: \.offset) { index, ch in
                    Chip(
                        text: String(ch), cursive: model.settings.cursive, selected: model.selectedLetter == index,
                        letter: true
                    ) {
                        model.select(letterAt: index)
                    }
                }
            }
            .padding(.horizontal, 12)
        }
    }
}

extension View {
    /// iOS 26 blurs scroll content near a scroll view's edges, which in a strip this short blurs every chip.
    @ViewBuilder func noScrollEdgeEffect() -> some View {
        if #available(iOS 26, *) {
            scrollEdgeEffectHidden(true)
        } else {
            self
        }
    }
}
