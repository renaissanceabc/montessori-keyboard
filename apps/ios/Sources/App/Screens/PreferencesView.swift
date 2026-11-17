import MontessoriCore
import MontessoriUI
import SwiftUI

/// A setup step: the three choices that change the tiles most. Everything here can be changed later in Settings.
struct PreferencesView: View {
    var next: () -> Void
    @Environment(AppModel.self) private var model
    @Environment(\.palette) private var palette

    var body: some View {
        @Bindable var model = model
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                ScreenHeading(title: "Make it yours", subtitle: "Three quick choices. You can change them any time in Settings.")
                Question(title: "Which order should the letters go in?") {
                    ChoiceCard(title: "ABC", detail: "Like the moveable alphabet box", selected: model.settings.order == .abc) {
                        model.settings.order = .abc
                    } preview: {
                        TileRow(letters: ["a", "b", "c"], cursive: model.settings.cursive)
                    }
                    ChoiceCard(title: "QWERTY", detail: "Like every other keyboard", selected: model.settings.order == .qwerty) {
                        model.settings.order = .qwerty
                    } preview: {
                        TileRow(letters: ["q", "w", "e"], cursive: model.settings.cursive)
                    }
                }
                Question(title: "Print or cursive?") {
                    ChoiceCard(title: "Print", detail: "Lowercase print letters", selected: !model.settings.cursive) {
                        model.settings.cursive = false
                    } preview: {
                        TileRow(letters: ["a", "b", "c"], cursive: false)
                    }
                    ChoiceCard(title: "Cursive", detail: "For children learning cursive", selected: model.settings.cursive) {
                        model.settings.cursive = true
                    } preview: {
                        TileRow(letters: ["a", "b", "c"], cursive: true)
                    }
                }
                Question(title: "Should shift make capitals?") {
                    ChoiceCard(title: "Lowercase only", detail: "Shift stays off", selected: !model.settings.capitalsWithShift) {
                        model.settings.capitalsWithShift = false
                    } preview: {
                        TileRow(letters: ["s", "a", "m"], cursive: model.settings.cursive)
                    }
                    ChoiceCard(title: "Capitals", detail: "Shift types one capital", selected: model.settings.capitalsWithShift) {
                        model.settings.capitalsWithShift = true
                    } preview: {
                        TileRow(letters: ["S", "a", "m"], cursive: model.settings.cursive)
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
            .padding(.bottom, 12)
        }
        .safeAreaInset(edge: .bottom) {
            PrimaryButton("Next", action: next)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(palette.page)
        }
        .pageBackground(palette.page)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) { StepDots(step: 0, of: 3) }
        }
    }
}

private struct Question<Content: View>: View {
    var title: String
    @ViewBuilder var content: Content
    @Environment(\.palette) private var palette

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(TileFont.text(16, weight: .semibold))
                .foregroundStyle(palette.ink)
                .accessibilityAddTraits(.isHeader)
            HStack(alignment: .top, spacing: 10) { content }
        }
    }
}

/// One of two answers to a question: a few tiles showing what it looks like, a name and a line.
private struct ChoiceCard<Preview: View>: View {
    var title: String
    var detail: String
    var selected: Bool
    var action: () -> Void
    @ViewBuilder var preview: Preview
    @Environment(\.palette) private var palette

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                preview
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(palette.tray, in: RoundedRectangle(cornerRadius: 9, style: .continuous))
                HStack(alignment: .top, spacing: 8) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title).font(TileFont.text(15, weight: .semibold)).foregroundStyle(palette.ink)
                        Text(detail).font(TileFont.text(13)).foregroundStyle(palette.ink2)
                    }
                    Spacer(minLength: 0)
                    Circle()
                        .strokeBorder(selected ? palette.vowel : palette.tileEdge, lineWidth: selected ? 6 : 2)
                        .frame(width: 20, height: 20)
                }
                .multilineTextAlignment(.leading)
            }
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(palette.card, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(selected ? palette.vowel : palette.line, lineWidth: selected ? 2.5 : 1.5)
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(title). \(detail)")
        .accessibilityAddTraits(selected ? [.isButton, .isSelected] : .isButton)
    }
}

/// A few small tiles, for the choice previews.
private struct TileRow: View {
    var letters: [String]
    var cursive: Bool
    @Environment(\.palette) private var palette

    var body: some View {
        HStack(spacing: 5) {
            ForEach(Array(letters.enumerated()), id: \.offset) { _, letter in
                Text(letter)
                    .font(TileFont.tile(size: 22, cursive: cursive))
                    .foregroundStyle(palette.color(for: LetterKind(Character(letter))))
                    .padding(.bottom, cursive ? 1 : 3)
                    .frame(width: 32, height: 38)
                    .background(
                        LinearGradient(colors: [palette.tileTop, palette.tileBottom], startPoint: .top, endPoint: .bottom),
                        in: RoundedRectangle(cornerRadius: 6, style: .continuous)
                    )
                    .background(RoundedRectangle(cornerRadius: 6, style: .continuous).fill(palette.tileEdge).offset(y: 1.5))
            }
        }
        .accessibilityHidden(true)
    }
}
