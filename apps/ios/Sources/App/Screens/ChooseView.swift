import MontessoriCore
import MontessoriUI
import SwiftUI

/// The setup step between turning the keyboard on and trying it: three questions that set up the tiles.
/// Each answer saves straight away, and Settings can change it later.
struct ChooseView: View {
    var next: () -> Void
    @Environment(AppModel.self) private var model
    @Environment(\.palette) private var palette

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    ScreenHeading(title: "Make it yours", subtitle: "Pick how the tiles look. You can change these later in Settings.")
                    question("Letter order") {
                        ChoiceTile(title: "ABC", selected: model.settings.order == .abc) { model.settings.order = .abc } preview: {
                            MiniTiles(letters: "abcde", cursive: model.settings.cursive)
                        }
                        ChoiceTile(title: "QWERTY", selected: model.settings.order == .qwerty) { model.settings.order = .qwerty } preview: {
                            MiniTiles(letters: "qwert", cursive: model.settings.cursive)
                        }
                    }
                    question("Letter shapes") {
                        ChoiceTile(title: "Print", selected: !model.settings.cursive) { model.settings.cursive = false } preview: {
                            MiniTiles(letters: "abc", cursive: false)
                        }
                        ChoiceTile(title: "Cursive", selected: model.settings.cursive) { model.settings.cursive = true } preview: {
                            MiniTiles(letters: "abc", cursive: true)
                        }
                    }
                    question("Capitals") {
                        ChoiceTile(title: "Lowercase only", selected: !model.settings.capitalsWithShift) {
                            model.settings.capitalsWithShift = false
                        } preview: {
                            MiniTiles(letters: "mia", cursive: model.settings.cursive)
                        }
                        ChoiceTile(title: "Shift for capitals", selected: model.settings.capitalsWithShift) {
                            model.settings.capitalsWithShift = true
                        } preview: {
                            MiniTiles(letters: "Mia", cursive: model.settings.cursive)
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 8)
                .padding(.bottom, 16)
            }
            PrimaryButton("Next", action: next)
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
        }
        .pageBackground(palette.paper)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) { StepDots(step: 1, of: 3) }
        }
    }

    private func question<Choices: View>(_ title: String, @ViewBuilder choices: () -> Choices) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(TileFont.text(13))
                .foregroundStyle(palette.muted)
                .accessibilityAddTraits(.isHeader)
            HStack(spacing: 10) { choices() }
        }
    }
}

/// One answer: a few tiles on a tray, and its name with a radio.
struct ChoiceTile<Preview: View>: View {
    var title: String
    var selected: Bool
    var action: () -> Void
    @ViewBuilder var preview: Preview
    @Environment(\.palette) private var palette

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                preview
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(palette.tray, in: RoundedRectangle(cornerRadius: 9, style: .continuous))
                HStack(spacing: 8) {
                    Circle()
                        .strokeBorder(selected ? palette.vowel : palette.tileEdge, lineWidth: selected ? 6 : 2)
                        .frame(width: 20, height: 20)
                    Text(title)
                        .font(TileFont.text(15, weight: .semibold))
                        .foregroundStyle(palette.ink)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .background(palette.card, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(selected ? palette.vowel : palette.line, lineWidth: selected ? 2.5 : 1.5)
            }
            .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(PressScale())
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title)
        .accessibilityAddTraits(selected ? [.isButton, .isSelected] : .isButton)
    }
}

/// A short row of small tiles, in the keyboard's colors.
struct MiniTiles: View {
    var letters: String
    var cursive: Bool
    @Environment(\.palette) private var palette

    var body: some View {
        HStack(spacing: 4) {
            ForEach(Array(letters.enumerated()), id: \.offset) { _, ch in
                Text(String(ch))
                    .font(TileFont.tile(size: cursive ? 14 : 18, cursive: cursive))
                    .foregroundStyle(palette.color(for: LetterKind(ch)))
                    .padding(.bottom, 2)
                    .frame(width: 22, height: 28)
                    .background(
                        LinearGradient(colors: [palette.tileTop, palette.tileBottom], startPoint: .top, endPoint: .bottom),
                        in: RoundedRectangle(cornerRadius: 5)
                    )
                    .background(RoundedRectangle(cornerRadius: 5).fill(palette.tileEdge).offset(y: 1.5))
            }
        }
        .accessibilityHidden(true)
    }
}

/// A press that sinks a little, so a tap feels heard.
struct PressScale: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}
