import SwiftUI

/// How wide a key is, in tiles. A letter tile is 1.
struct KeyWeight: LayoutValueKey {
    static let defaultValue: CGFloat = 1
}

extension View {
    func keyWeight(_ weight: CGFloat) -> some View { layoutValue(key: KeyWeight.self, value: weight) }
}

/// A row of keys on a ten-tile grid, so a tile is the same width in every row. A row that would overflow
/// (ABC's last row with shift and delete) scales down to fit; a shorter row sits in the middle.
struct KeyRow: Layout {
    var spacing: CGFloat = 6
    var height: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        CGSize(width: proposal.width ?? 375, height: height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard !subviews.isEmpty else { return }
        let weights = subviews.map { $0[KeyWeight.self] }
        let gaps = spacing * CGFloat(subviews.count - 1)
        var unit = (bounds.width - spacing * 9) / 10
        let natural = weights.reduce(0, +) * unit + gaps
        if natural > bounds.width { unit = (bounds.width - gaps) / weights.reduce(0, +) }
        let total = weights.reduce(0, +) * unit + gaps
        var x = bounds.minX + (bounds.width - total) / 2
        for (subview, weight) in zip(subviews, weights) {
            let width = weight * unit
            subview.place(at: CGPoint(x: x, y: bounds.minY), proposal: ProposedViewSize(width: width, height: height))
            x += width + spacing
        }
    }
}

/// Press handling shared by every key: tap on release (like Apple's keyboard), an optional hold, and an optional
/// repeat for delete. `label` gets whether the key is down so it can sink. After a hold, the finger can keep
/// sliding: `onSlide` and `onLift` get its point in the keyboard's coordinate space (`KeyboardView.space`).
struct KeyButton<Label: View>: View {
    var accessibilityLabel: String
    var repeats = false
    var onTap: () -> Void
    /// Gets the key's frame in the keyboard's coordinate space, so a popup can sit over it.
    var onHold: ((CGRect) -> Void)?
    var onSlide: ((CGPoint) -> Void)?
    var onLift: (() -> Void)?
    @ViewBuilder var label: (_ pressed: Bool) -> Label

    @State private var pressed = false
    @State private var held = false
    @State private var timer: Task<Void, Never>?
    @State private var frame: CGRect = .zero

    var body: some View {
        label(pressed)
            .contentShape(Rectangle())
            .onGeometryChange(for: CGRect.self) { $0.frame(in: .named(KeyboardView.space)) } action: { frame = $0 }
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .named(KeyboardView.space))
                    .onChanged { value in
                        if !pressed { begin() } else if held { onSlide?(value.location) }
                    }
                    .onEnded { _ in end() }
            )
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(accessibilityLabel)
            .accessibilityAddTraits(.isKeyboardKey)
            .accessibilityAction { onTap() }
    }

    private func begin() {
        pressed = true
        held = false
        if repeats {
            onTap()
            timer = Task {
                try? await Task.sleep(for: .milliseconds(450))
                while !Task.isCancelled {
                    held = true
                    onTap()
                    try? await Task.sleep(for: .milliseconds(90))
                }
            }
        } else if let onHold {
            timer = Task {
                try? await Task.sleep(for: .milliseconds(400))
                guard !Task.isCancelled else { return }
                held = true
                onHold(frame)
            }
        }
    }

    private func end() {
        timer?.cancel()
        timer = nil
        if held, !repeats { onLift?() }
        if !repeats && !held { onTap() }
        pressed = false
    }
}

/// A maple (or walnut) tile: a gradient face on a darker edge that disappears when it's pressed.
struct TileFace<Content: View>: View {
    var pressed: Bool
    var function = false
    var cornerRadius: CGFloat = 7
    @ViewBuilder var content: Content
    @Environment(\.palette) private var palette

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        let top = function ? palette.keyTop : (pressed ? palette.tilePressed : palette.tileTop)
        let bottom = function ? palette.keyBottom : (pressed ? palette.tilePressed : palette.tileBottom)
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                shape.fill(LinearGradient(colors: [top, bottom], startPoint: .top, endPoint: .bottom))
                    .overlay(alignment: .top) {
                        if !function {
                            shape.stroke(palette.tileHighlight, lineWidth: 1).mask(alignment: .top) { Rectangle().frame(height: 2) }
                        }
                    }
            }
            .background {
                shape.fill(function ? palette.keyEdge : palette.tileEdge)
                    .offset(y: pressed ? 0 : 2)
                    .shadow(color: palette.shadow, radius: pressed ? 1 : 2.5, y: pressed ? 1 : 3)
            }
            .offset(y: pressed ? 2 : 0)
            .animation(.easeOut(duration: 0.08), value: pressed)
    }
}

/// A letter tile, blue or red. While it's down (and no popup is open) a larger copy lifts above the finger,
/// so small hands can see what they hit.
struct LetterKey: View {
    var label: String
    var color: Color
    var cursive: Bool
    var fontSize: CGFloat
    var lifts = true
    var onTap: () -> Void
    var onHold: ((CGRect) -> Void)?
    var onSlide: ((CGPoint) -> Void)?
    var onLift: (() -> Void)?

    var body: some View {
        KeyButton(accessibilityLabel: label, onTap: onTap, onHold: onHold, onSlide: onSlide, onLift: onLift) { pressed in
            TileFace(pressed: pressed) {
                letter(size: fontSize)
            }
            .overlay(alignment: .bottom) {
                if pressed && lifts {
                    LiftedTile { letter(size: fontSize * 1.42) }
                }
            }
        }
    }

    private func letter(size: CGFloat) -> some View {
        Text(label)
            .font(TileFont.tile(size: size, cursive: cursive))
            .foregroundStyle(color)
            .padding(.bottom, cursive ? 2 : 4)
            .minimumScaleFactor(0.6)
            .lineLimit(1)
    }
}

/// The lifted copy of a pressed tile: about 1.4 times its size, its bottom a quarter of the way down the key.
struct LiftedTile<Content: View>: View {
    @ViewBuilder var content: Content
    @Environment(\.palette) private var palette

    var body: some View {
        GeometryReader { proxy in
            let key = proxy.size
            let size = CGSize(width: key.width * 1.38, height: key.height * 1.35)
            let shape = RoundedRectangle(cornerRadius: 9, style: .continuous)
            content
                .frame(width: size.width, height: size.height)
                .background {
                    shape.fill(LinearGradient(colors: [palette.tileTop, palette.tileBottom], startPoint: .top, endPoint: .bottom))
                }
                .background {
                    shape.fill(palette.tileEdge)
                        .offset(y: 4)
                        .shadow(color: palette.liftShadow, radius: 9, y: 10)
                }
                .position(x: key.width / 2, y: key.height * 0.26 - size.height / 2)
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

/// Shift, delete, 123, space and return: darker keys with an icon or a short word.
struct FunctionKey<Icon: View>: View {
    var accessibilityLabel: String
    var repeats = false
    var dimmed = false
    var highlighted = false
    var onTap: () -> Void
    @ViewBuilder var icon: Icon
    @Environment(\.palette) private var palette

    var body: some View {
        KeyButton(accessibilityLabel: accessibilityLabel, repeats: repeats, onTap: onTap) { pressed in
            TileFace(pressed: pressed || highlighted, function: !highlighted) {
                icon
                    .font(TileFont.text(15, weight: .medium))
                    .foregroundStyle(palette.keyInk)
                    .opacity(dimmed ? 0.45 : 1)
            }
        }
    }
}

enum KeyIcon {
    static let shift = "shift"
    static let shiftOn = "shift.fill"
    static let delete = "delete.left"
    static let returnKey = "return"
    static let globe = "globe"
}
