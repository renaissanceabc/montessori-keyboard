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
        .overlay(alignment: .bottom) { Rectangle().fill(palette.stripLine).frame(height: 1) }
    }

    @ViewBuilder private var rhymes: some View {
        if let family = model.family, !model.rhymes.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    Text("-" + family)
                        .font(TileFont.tile(size: 15, cursive: false))
                        .foregroundStyle(palette.hint)
                        .accessibilityLabel("Rhymes with \(family)")
                    ForEach(model.rhymes, id: \.self) { rhyme in
                        Chip(text: rhyme, cursive: model.settings.cursive) { model.swap(to: rhyme) }
                    }
                }
                .padding(.horizontal, 12)
            }
            .noScrollEdgeEffect()
        } else {
            Text("Rhymes show up here")
                .font(TileFont.text(13))
                .foregroundStyle(palette.hint)
                .padding(.horizontal, 12)
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
                if model.selectedLetter != nil {
                    Text("Tap a tile")
                        .font(TileFont.text(13))
                        .foregroundStyle(palette.hint)
                }
            }
            .padding(.horizontal, 12)
        } else {
            Text("Tap a letter to change it")
                .font(TileFont.text(13))
                .foregroundStyle(palette.hint)
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
