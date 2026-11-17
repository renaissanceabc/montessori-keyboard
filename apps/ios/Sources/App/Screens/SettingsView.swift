import MontessoriCore
import MontessoriUI
import SwiftUI

/// Settings, with the keyboard pinned at the top so every change shows (and sounds) right away.
struct SettingsView: View {
    @Environment(AppModel.self) private var model
    @Environment(\.palette) private var palette
    @State private var previewText = TypedText(limit: 40)

    var body: some View {
        @Bindable var model = model
        VStack(spacing: 0) {
            HStack {
                Text("Settings")
                    .font(TileFont.heading(30))
                    .foregroundStyle(palette.ink)
                    .accessibilityAddTraits(.isHeader)
                Spacer()
                NavigationLink {
                    PadView()
                } label: {
                    Image(systemName: "pencil.line")
                        .font(.body.weight(.semibold))
                        .foregroundStyle(palette.ink)
                        .frame(width: 44, height: 44)
                        .background(palette.card.opacity(0.8), in: Circle())
                        .shadow(color: palette.shadow.opacity(0.5), radius: 6, y: 3)
                }
                .accessibilityLabel("Open a blank pad")
            }
            .padding(.horizontal, 20)
            .padding(.top, 8)
            .padding(.bottom, 12)

            // The preview never shows the strip: it's there to try the tiles.
            LiveKeyboard(settings: previewSettings, text: previewText)
                .padding(14)
                .background(palette.tray, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                .padding(.horizontal, 12)

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    SettingsGroup(title: "Keyboard") {
                        SegmentRow(title: "Order", selection: $model.settings.order, options: [(.abc, "ABC"), (.qwerty, "QWERTY")])
                        SegmentRow(title: "Letter shapes", selection: $model.settings.cursive, options: [(false, "Print"), (true, "Cursive")])
                        ToggleRow(title: "Capitals with shift", isOn: $model.settings.capitalsWithShift)
                    }
                    SettingsGroup(title: "Learning") {
                        ToggleRow(title: "Phonograms on long press", isOn: $model.settings.phonograms)
                        LinkRow(title: "Strip", value: model.settings.strip.title) { StripOptionsView() }
                        LinkRow(title: "Numbers", value: model.settings.numbers.title) { NumbersOptionsView() }
                    }
                    SettingsGroup(title: "Sound", footer: "Tap the tiles above to hear them. On other apps, sounds need Allow Full Access in iPhone Settings.") {
                        ToggleRow(title: "Say letter sounds", isOn: $model.settings.letterSounds)
                        ToggleRow(title: "Key clicks", isOn: $model.settings.keyClicks)
                    }
                    SettingsGroup(title: "More") {
                        LinkRow(title: "Setup guide") { GuideView() }
                        LinkRow(title: "About and source code") { AboutView() }
                    }
                    HStack(spacing: 8) {
                        Circle().fill(model.keyboardEnabled ? palette.success : Color(hex: BeadStair.ten)).frame(width: 8, height: 8)
                        Text(model.statusLine)
                    }
                    .font(TileFont.text(13))
                    .foregroundStyle(palette.muted)
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
        }
        .pageBackground(palette.page)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear { model.refreshStatus() }
    }

    private var previewSettings: KeyboardSettings {
        var settings = model.settings
        settings.strip = .off
        return settings
    }
}

/// What the strip above the tiles shows.
struct StripOptionsView: View {
    @Environment(AppModel.self) private var model
    @Environment(\.palette) private var palette

    var body: some View {
        OptionsPage(title: "Strip", subtitle: "What the row above the tiles shows. It never autocorrects.") {
            OptionCard(title: StripMode.rhymes.title, detail: "Rhyming words to swap in.", selected: model.settings.strip == .rhymes, action: { pick(.rhymes) }) {
                MiniStrip {
                    Text("-ig").font(TileFont.tile(size: 14, cursive: false)).foregroundStyle(palette.muted)
                    ForEach(["big", "dig", "fig", "wig"], id: \.self) { MiniChip(text: $0) }
                }
            }
            OptionCard(title: StripMode.letters.title, detail: "Tap a letter to change it.", selected: model.settings.strip == .letters, action: { pick(.letters) }) {
                MiniStrip {
                    ForEach(["p", "i", "g"], id: \.self) { MiniChip(text: $0) }
                    Text("tap a tile to change it").font(TileFont.text(12.5)).foregroundStyle(palette.muted).padding(.leading, 6)
                }
            }
            OptionCard(title: StripMode.off.title, detail: "Nothing. Just the tiles.", selected: model.settings.strip == .off, action: { pick(.off) }) {
                MiniStrip { EmptyView() }
            }
        }
    }

    private func pick(_ mode: StripMode) {
        model.settings.strip = mode
    }
}

/// How the 123 keys show quantity.
struct NumbersOptionsView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        OptionsPage(title: "Numbers", subtitle: "How the 123 keys show quantity.") {
            card(.beads, "Each key shows its number as bead-stair beads, so 3 is always three pink beads.")
            card(.rods, "Red and blue stripes, like the number rods. One stripe per unit.")
            card(.plain, "Just the numerals.")
        }
    }

    private func card(_ style: NumberStyle, _ detail: String) -> some View {
        OptionCard(title: style.title, detail: detail, selected: model.settings.numbers == style, action: { model.settings.numbers = style }) {
            MiniNumbers(style: style)
        }
    }
}

struct OptionsPage<Content: View>: View {
    var title: String
    var subtitle: String
    @ViewBuilder var content: Content
    @Environment(\.palette) private var palette

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ScreenHeading(title: title, subtitle: subtitle)
                content
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 28)
        }
        .pageBackground(palette.page)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MiniStrip<Content: View>: View {
    @ViewBuilder var content: Content
    @Environment(\.palette) private var palette

    var body: some View {
        HStack(spacing: 5) { content }
            .padding(.horizontal, 8)
            .frame(maxWidth: .infinity, minHeight: 44, maxHeight: 44, alignment: .leading)
            .background(palette.tray, in: RoundedRectangle(cornerRadius: 9, style: .continuous))
            .accessibilityHidden(true)
    }
}

struct MiniChip: View {
    var text: String
    @Environment(\.palette) private var palette

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(text.enumerated()), id: \.offset) { _, ch in
                Text(String(ch)).foregroundStyle(palette.color(for: LetterKind(ch)))
            }
        }
        .font(TileFont.tile(size: 19, cursive: false))
        .padding(.horizontal, 9)
        .padding(.bottom, 3)
        .frame(height: 32)
        .background(palette.tileTop, in: RoundedRectangle(cornerRadius: 7))
        .background(RoundedRectangle(cornerRadius: 7).fill(palette.tileEdge).offset(y: 1))
    }
}

struct MiniNumbers: View {
    var style: NumberStyle
    @Environment(\.palette) private var palette

    var body: some View {
        HStack(spacing: 6) {
            ForEach(1...5, id: \.self) { digit in
                VStack(spacing: 3) {
                    Text(String(digit)).font(TileFont.tile(size: 19, cursive: false)).foregroundStyle(palette.ink)
                    NumberMarks(digit: digit, style: style)
                }
                .frame(maxWidth: .infinity, minHeight: 42)
                .background(LinearGradient(colors: [palette.tileTop, palette.tileBottom], startPoint: .top, endPoint: .bottom), in: RoundedRectangle(cornerRadius: 6))
                .background(RoundedRectangle(cornerRadius: 6).fill(palette.tileEdge).offset(y: 1.5))
            }
        }
        .padding(.horizontal, 8)
        .frame(height: 56)
        .background(palette.tray, in: RoundedRectangle(cornerRadius: 9, style: .continuous))
        .accessibilityHidden(true)
    }
}
