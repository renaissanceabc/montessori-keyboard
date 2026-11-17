import MontessoriCore
import SwiftUI

/// Where the phonogram popup and each of its teams sit, worked out from the held tile's frame so the view and
/// the finger's hit-testing agree. Everything is in the keyboard's coordinate space.
struct PopupLayout: Equatable {
    static let chipHeight: CGFloat = 42
    static let spacing: CGFloat = 5
    static let padding: CGFloat = 5
    static let gap: CGFloat = 6

    var frame: CGRect
    var chips: [CGRect]

    init(key: CGRect, teams: [String], in bounds: CGRect) {
        let longest = CGFloat(teams.map(\.count).max() ?? 1)
        let count = CGFloat(teams.count)
        let room = bounds.width - 8 - 2 * Self.padding - Self.spacing * max(count - 1, 0)
        let chipWidth = min(max(key.width + 6, longest * 15 + 20), room / max(count, 1))
        let width = chipWidth * count + Self.spacing * max(count - 1, 0) + 2 * Self.padding
        let height = Self.chipHeight + 2 * Self.padding

        // Centered over the tile, kept on screen; above it when there's room, otherwise as high as it goes.
        let x = min(max(key.midX - width / 2, bounds.minX + 4), bounds.maxX - 4 - width)
        let y = max(key.minY - Self.gap - height, bounds.minY + 2)
        frame = CGRect(x: x, y: y, width: width, height: height)
        chips = teams.indices.map { index in
            CGRect(
                x: x + Self.padding + CGFloat(index) * (chipWidth + Self.spacing),
                y: y + Self.padding,
                width: chipWidth,
                height: Self.chipHeight
            )
        }
    }

    /// The team under a finger, a little generous around the popup so small fingers find it.
    func team(at point: CGPoint) -> Int? {
        guard point.y >= frame.minY - 24, point.y <= frame.maxY + 12 else { return nil }
        guard point.x >= frame.minX - 12, point.x <= frame.maxX + 12 else { return nil }
        let nearest = chips.indices.min { abs(chips[$0].midX - point.x) < abs(chips[$1].midX - point.x) }
        return nearest
    }
}

/// The letter teams for a held tile, in a little tray above it: slide onto one and let go, or lift and tap one.
struct PhonogramPopup: View {
    @Bindable var model: KeyboardModel
    var layout: PopupLayout
    @Environment(\.palette) private var palette

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 12, style: .continuous)
        // Laid out with padding rather than offsets, so taps land where the chips are drawn.
        HStack(spacing: PopupLayout.spacing) {
            ForEach(Array(model.trayTeams.enumerated()), id: \.offset) { index, team in
                if layout.chips.indices.contains(index) {
                    PopupChip(team: team, cursive: model.settings.cursive, highlighted: model.highlightedTeam == index) {
                        model.tap(team: team)
                    }
                    .frame(width: layout.chips[index].width, height: layout.chips[index].height)
                }
            }
        }
        .padding(PopupLayout.padding)
        .background {
            shape
                .fill(palette.tray)
                .overlay { shape.strokeBorder(palette.tileEdge, lineWidth: 1) }
                .shadow(color: palette.shadow, radius: 8, y: 4)
        }
        .fixedSize()
        .padding(.leading, layout.frame.minX)
        .padding(.top, layout.frame.minY)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Letter teams")
    }
}

private struct PopupChip: View {
    var team: String
    var cursive: Bool
    var highlighted: Bool
    var onTap: () -> Void
    @Environment(\.palette) private var palette

    var body: some View {
        Button(action: onTap) {
            ColoredWord(word: team, size: 22, cursive: cursive)
                .padding(.bottom, 3)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
        }
        .buttonStyle(PopupChipStyle(highlighted: highlighted))
        .accessibilityLabel(team)
    }
}

private struct PopupChipStyle: ButtonStyle {
    var highlighted: Bool
    @Environment(\.palette) private var palette

    func makeBody(configuration: Configuration) -> some View {
        TileFace(pressed: configuration.isPressed || highlighted, cornerRadius: 8) {
            configuration.label
        }
        .overlay {
            if highlighted {
                RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(palette.vowel, lineWidth: 2).offset(y: 2)
            }
        }
        .scaleEffect(highlighted ? 1.06 : 1)
        .animation(.easeOut(duration: 0.08), value: highlighted)
    }
}
