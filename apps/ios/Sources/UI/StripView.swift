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

/// A small tile in the strip: a rhyme, a phonogram, or one letter of the word being changed.
struct Chip: View {
    var text: String
    var cursive: Bool
    var selected = false
    var onTap: () -> Void

    var body: some View {
        // A plain Button, not KeyButton, so the strip's horizontal scroll still works.
        Button(action: onTap) {
            ColoredWord(word: text, size: 20, cursive: cursive)
                .padding(.horizontal, 10)
                .padding(.bottom, 3)
        }
        .buttonStyle(ChipStyle(selected: selected))
        .accessibilityLabel(text)
        .accessibilityAddTraits(selected ? .isSelected : [])
    }
}

struct ChipStyle: ButtonStyle {
    var selected: Bool
    @Environment(\.palette) private var palette

    func makeBody(configuration: Configuration) -> some View {
        TileFace(pressed: configuration.isPressed || selected, cornerRadius: 7) {
            configuration.label
        }
        .fixedSize(horizontal: true, vertical: false)
        .frame(height: 34)
        .overlay {
            if selected {
                RoundedRectangle(cornerRadius: 7).stroke(palette.vowel, lineWidth: 2).offset(y: 2)
            }
        }
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
        .overlay(alignment: .bottom) { Rectangle().fill(palette.line).frame(height: 1) }
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
                .padding(.horizontal, 10)
            }
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
                    Chip(text: String(ch), cursive: model.settings.cursive, selected: model.selectedLetter == index) {
                        model.select(letterAt: index)
                    }
                }
                if model.selectedLetter != nil {
                    Text("Tap a tile")
                        .font(TileFont.text(13))
                        .foregroundStyle(palette.hint)
                }
            }
            .padding(.horizontal, 10)
        } else {
            Text("Tap a letter to change it")
                .font(TileFont.text(13))
                .foregroundStyle(palette.hint)
                .padding(.horizontal, 12)
        }
    }
}
