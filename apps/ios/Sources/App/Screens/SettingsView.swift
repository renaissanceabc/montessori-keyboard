import MontessoriCore
import MontessoriUI
import SwiftUI

/// Settings, with the keyboard pinned at the top so every change shows (and sounds) right away. As the settings
/// scroll up, the tray settles into a compact keyboard to give them room: it keeps its full width, lined up with
/// the groups below, while its tiles get shorter and its rows and padding tighter. It follows the finger.
struct SettingsView: View {
    /// Points of scrolling over which the tray settles.
    static let settleDistance: CGFloat = 120
    /// The tray's padding at rest and compact, and the gap above it.
    static let restPadding: CGFloat = 14
    static let compactPadding: CGFloat = 10
    static let topGap: CGFloat = 4
    /// How far below the tray the rows fade out.
    static let fade: CGFloat = 14

    @Environment(AppModel.self) private var model
    @Environment(\.palette) private var palette
    @State private var previewText = TypedText(limit: 40)
    @State private var scrolled: CGFloat = 0

    /// 0 at rest, 1 once the settings have scrolled `settleDistance`, eased at both ends so the tray starts and
    /// finishes settling gently rather than at a constant rate.
    private var settle: CGFloat {
        let t = min(max(scrolled / Self.settleDistance, 0), 1)
        return t * t * (3 - 2 * t)
    }

    /// The pinned area's height at rest. The settings start under it, and it never changes while scrolling, so the
    /// scroll content never relayouts.
    private var restHeight: CGFloat {
        KeyboardView.height(for: previewSettings) + 2 * Self.restPadding + Self.topGap
    }

    var body: some View {
        @Bindable var model = model
        VStack(spacing: 0) {
            // The settings scroll under the pinned preview. Their top margin is the preview's rest height, fixed, so
            // only the small tray relayouts as it settles.
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 18) {
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
                        VStack(alignment: .leading, spacing: 6) {
                            SettingsGroup(title: "More") {
                                LinkRow(title: "Setup guide") { GuideView() }
                                LinkRow(title: "About and source code") { AboutView() }
                            }
                            HStack(spacing: 8) {
                                Circle().fill(model.keyboardEnabled ? palette.success : Color(hex: BeadStair.ten)).frame(width: 8, height: 8)
                                Text(model.statusLine)
                            }
                            .font(TileFont.text(13, relativeTo: .footnote))
                            .foregroundStyle(model.keyboardEnabled ? palette.successInk : palette.muted)
                            .padding(.horizontal, 4)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 28)
                }
                .contentMargins(.top, restHeight, for: .scrollContent)
                .onScrollGeometryChange(for: CGFloat.self) { $0.contentOffset.y + $0.contentInsets.top } action: { _, offset in
                    scrolled = offset
                }

                preview
            }
        }
        .pageBackground(palette.page)
        // The native bar stays up on every page in this stack, so push and pop (and swipe back) are Apple's own.
        // The large title sits inline, so it never collapses over the pinned keyboard.
        .navigationTitle("Settings")
        .toolbarTitleDisplayMode(.inlineLarge)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    PadView()
                } label: {
                    Image(systemName: "pencil.line")
                }
                .accessibilityLabel("Open a blank pad")
            }
        }
        .onAppear { model.refreshStatus() }
    }

    /// The pinned tray. The preview never shows the strip: it's there to try the tiles. The page color behind it
    /// hides the rows passing under, and they fade out just below its edge.
    private var preview: some View {
        let padding = Self.restPadding - (Self.restPadding - Self.compactPadding) * settle
        let shape = RoundedRectangle(cornerRadius: 12, style: .continuous)
        return LiveKeyboard(settings: previewSettings, text: previewText, compact: settle)
            .padding(padding)
            .background(palette.tray, in: shape)
            .overlay { shape.strokeBorder(palette.line, lineWidth: 1) }
            .padding(.horizontal, 16)
            .padding(.top, Self.topGap)
            .background(palette.page)
            // Rows fade out as they slide under the tray rather than being cut flat, and the tray's own edge is the
            // divider, so there's no separate line or empty band below it.
            .overlay(alignment: .bottom) {
                LinearGradient(colors: [palette.page, palette.page.opacity(0)], startPoint: .top, endPoint: .bottom)
                    .frame(height: Self.fade)
                    .offset(y: Self.fade)
                    .opacity(min(max(scrolled / 16, 0), 1))
                    .allowsHitTesting(false)
            }
            .accessibilitySortPriority(1)
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
                    ForEach(["p", "i", "g"], id: \.self) { MiniChip(text: $0, letter: true) }
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
                Text(subtitle)
                    .font(TileFont.text(15))
                    .foregroundStyle(palette.ink2)
                content
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 28)
        }
        .pageBackground(palette.page)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
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
    var letter = false
    @Environment(\.palette) private var palette

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(text.enumerated()), id: \.offset) { _, ch in
                Text(String(ch)).foregroundStyle(palette.color(for: LetterKind(ch)))
            }
        }
        .font(TileFont.tile(size: 19, cursive: false))
        .padding(.horizontal, letter ? 0 : 9)
        .padding(.bottom, letter ? 2 : 3)
        .frame(width: letter ? 26 : nil, height: 32)
        .background(palette.chipTop, in: RoundedRectangle(cornerRadius: letter ? 5 : 7))
        .background(RoundedRectangle(cornerRadius: letter ? 5 : 7).fill(palette.tileEdge).offset(y: 1))
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
