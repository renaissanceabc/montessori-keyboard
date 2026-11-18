import SwiftUI

/// Where the phonogram popup and its choices sit, in the keyboard's coordinate space (`KeyboardView.space`).
/// The letter's own tile sits over the held key, like Apple's accent picker, and its teams run on to the right.
/// A keyboard can't draw above its own frame, so over the top row the popup stops at the keyboard's top edge.
struct PopupLayout: Equatable {
    static let chip = CGSize(width: 38, height: 44)
    static let gap: CGFloat = 5
    static let inset: CGFloat = 6
    static let margin: CGFloat = 4

    let frame: CGRect
    let chips: [CGRect]

    init(anchor: CGRect, count: Int, width: CGFloat) {
        let n = CGFloat(max(count, 1))
        let room = (width - 2 * Self.margin - 2 * Self.inset - (n - 1) * Self.gap) / n
        let chipWidth = min(Self.chip.width, room)
        let size = CGSize(
            width: n * chipWidth + (n - 1) * Self.gap + 2 * Self.inset,
            height: Self.chip.height + 2 * Self.inset + 2
        )
        let x = min(max(anchor.midX - Self.inset - chipWidth / 2, Self.margin), width - Self.margin - size.width)
        let y = max(anchor.minY - 4 - size.height, 0)
        frame = CGRect(origin: CGPoint(x: x, y: y), size: size)
        chips = (0..<max(count, 0)).map { index in
            CGRect(
                x: x + Self.inset + CGFloat(index) * (chipWidth + Self.gap),
                y: y + Self.inset,
                width: chipWidth,
                height: Self.chip.height
            )
        }
    }

    /// The choice under the finger: the nearest tile across, while the finger stays near the popup and the held
    /// key. Sliding well away chooses nothing, so lifting there types nothing.
    func choice(at point: CGPoint, anchor: CGRect) -> Int? {
        guard point.y >= frame.minY - 40, point.y <= anchor.maxY + 24,
            point.x >= frame.minX - 24, point.x <= frame.maxX + 24
        else { return nil }
        return chips.indices.min { abs(chips[$0].midX - point.x) < abs(chips[$1].midX - point.x) }
    }
}

/// The letter and its teams on a darker tray over the held tile. The one under the finger is lit and outlined;
/// lifting types it. If the finger lifted away from them all, the popup stays and its tiles can be tapped.
struct PhonogramPopup: View {
    var choices: [String]
    var layout: PopupLayout
    var chosen: Int?
    var cursive: Bool
    var onPick: (Int) -> Void
    @Environment(\.palette) private var palette

    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(palette.popup)
                .shadow(color: palette.popupShadow, radius: 8, y: 6)
                .frame(width: layout.frame.width, height: layout.frame.height)
            ForEach(Array(zip(choices.indices, choices)), id: \.0) { index, choice in
                let chip = layout.chips[index]
                Button {
                    onPick(index)
                } label: {
                    PopupChip(text: choice, cursive: cursive, chosen: chosen == index)
                }
                .buttonStyle(.plain)
                .frame(width: chip.width, height: chip.height)
                .accessibilityLabel(choice)
                .offset(x: chip.minX - layout.frame.minX, y: chip.minY - layout.frame.minY)
            }
        }
        .frame(width: layout.frame.width, height: layout.frame.height, alignment: .topLeading)
        .offset(x: layout.frame.minX, y: layout.frame.minY)
    }
}

private struct PopupChip: View {
    var text: String
    var cursive: Bool
    var chosen: Bool
    @Environment(\.palette) private var palette

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: 7, style: .continuous)
        ColoredWord(word: text, size: 20, cursive: cursive)
            .minimumScaleFactor(0.6)
            .padding(.bottom, 3)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                if chosen {
                    shape.fill(palette.tilePressed)
                } else {
                    shape.fill(
                        LinearGradient(
                            colors: [palette.tileTop, palette.tileBottom], startPoint: .top, endPoint: .bottom))
                }
            }
            .background {
                if !chosen { shape.fill(palette.tileEdge).offset(y: 2) }
            }
            .overlay {
                if chosen { shape.strokeBorder(palette.vowel, lineWidth: 3) }
            }
    }
}
