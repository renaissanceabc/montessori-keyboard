import MontessoriCore
import SwiftUI

/// The quantity under a digit: dots in the bead-stair color, or a rod of alternating red and blue segments.
public struct NumberMarks: View {
    public var digit: Int
    public var style: NumberStyle

    public init(digit: Int, style: NumberStyle) {
        self.digit = digit
        self.style = style
    }

    public var body: some View {
        switch style {
        case .plain:
            EmptyView()
        case .beads:
            if let hex = BeadStair.color(for: digit) {
                let columns = Array(repeating: GridItem(.fixed(4), spacing: 1.5), count: min(digit, 5))
                LazyVGrid(columns: columns, spacing: 1.5) {
                    ForEach(0..<digit, id: \.self) { _ in
                        Circle()
                            .fill(Color(hex: hex))
                            .overlay { if digit == 7 { Circle().stroke(Color(hex: 0xBFAF98), lineWidth: 0.6) } }
                            .frame(width: 4, height: 4)
                    }
                }
                .fixedSize()
                .accessibilityHidden(true)
            }
        case .rods:
            if digit > 0 {
                HStack(spacing: 0) {
                    ForEach(0..<digit, id: \.self) { index in
                        Rectangle()
                            .fill(Color(hex: index.isMultiple(of: 2) ? 0xD2232A : 0x1E5BB8))
                            .frame(width: digit > 6 ? 3 : 4, height: 4)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 1.5))
                .accessibilityHidden(true)
            }
        }
    }
}

/// A digit key: the number, with its beads or rod under it.
struct DigitKey: View {
    var digit: Int
    var style: NumberStyle
    var onTap: () -> Void
    @Environment(\.palette) private var palette

    var body: some View {
        KeyButton(accessibilityLabel: String(digit), onTap: onTap) { pressed in
            TileFace(pressed: pressed) {
                VStack(spacing: 3) {
                    Text(String(digit))
                        .font(TileFont.tile(size: 22, cursive: false))
                        .foregroundStyle(palette.ink)
                    NumberMarks(digit: digit, style: style)
                }
                .padding(.bottom, 3)
            }
        }
    }
}
