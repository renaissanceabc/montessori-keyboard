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

    /// Resets by itself if the system cancels the touch, so a key never stays stuck down.
    @GestureState private var pressed = false
    @State private var active = false
    @State private var held = false
    @State private var timer: Task<Void, Never>?
    @State private var frame: CGRect = .zero

    var body: some View {
        label(pressed)
            .contentShape(Rectangle())
            .onGeometryChange(for: CGRect.self) { $0.frame(in: .named(KeyboardView.space)) } action: { frame = $0 }
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .named(KeyboardView.space))
                    .updating($pressed) { _, pressed, _ in pressed = true }
                    .onChanged { value in
                        if !active { begin() } else if held { onSlide?(value.location) }
                    }
                    .onEnded { _ in end() }
            )
            .onChange(of: pressed) { _, isPressed in
                // Cancelled by the system without an end: drop the press without typing.
                if !isPressed, active { cancel() }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(accessibilityLabel)
            .accessibilityAddTraits(.isKeyboardKey)
            .accessibilityAction { onTap() }
    }

    private func begin() {
        active = true
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
        guard active else { return }
        timer?.cancel()
        timer = nil
        active = false
        if held, !repeats { onLift?() }
        if !repeats && !held { onTap() }
        held = false
    }

    private func cancel() {
        timer?.cancel()
        timer = nil
        active = false
        held = false
    }
}

/// A maple (or walnut) tile: a gradient face on a darker edge, as the canvas's Tiles board draws it. Pressing sinks
/// the face onto its edge without changing its color; only a lit key (shift when on) gets the pale face, and it stays
/// raised.
struct TileFace<Content: View>: View {
    var pressed: Bool
    var function = false
    var lit = false
    var cornerRadius: CGFloat = 7
    @ViewBuilder var content: Content
    @Environment(\.palette) private var palette

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        let colors = lit
            ? [palette.tilePressed, palette.tilePressed]
            : function ? [palette.keyTop, palette.keyBottom] : [palette.tileTop, palette.tileBottom]
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background {
                shape.fill(LinearGradient(colors: colors, startPoint: .top, endPoint: .bottom))
                    .overlay {
                        // The 1pt highlight along the top of a letter tile.
                        if !function && !lit {
                            shape.strokeBorder(palette.tileHighlight, lineWidth: 1)
                                .mask(alignment: .top) { Rectangle().frame(height: 1) }
                        }
                    }
            }
            .background {
                // The edge, 2pt under the face, then the soft shadow, 3pt under the face.
                shape.fill(function ? palette.keyEdge : palette.tileEdge)
                    .offset(y: pressed ? 0 : 2)
            }
            .background {
                shape.fill(palette.tileEdge)
                    .shadow(color: palette.shadow, radius: pressed ? 1 : 2.5, y: pressed ? 1 : 3)
            }
            .offset(y: pressed ? 2 : 0)
            // Sinks at once, rises over 80ms, like the canvas's tiles.
            .animation(pressed ? nil : .easeOut(duration: 0.08), value: pressed)
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
            .padding(.bottom, cursive ? 2 : 3)
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
    var highlighted = false
    var onTap: () -> Void
    @ViewBuilder var icon: Icon
    @Environment(\.palette) private var palette

    var body: some View {
        KeyButton(accessibilityLabel: accessibilityLabel, repeats: repeats, onTap: onTap) { pressed in
            TileFace(pressed: pressed, function: true, lit: highlighted) {
                icon
                    .font(.custom(TileFont.medium, fixedSize: 15))
                    .foregroundStyle(palette.keyInk)
            }
        }
    }
}

/// The function keys' icons, drawn as the canvas draws them: 1.8pt strokes with round joins, in a 24pt box. Shift
/// stays an outline when it's on; the key lights up instead.
@MainActor
public enum KeyIcon {
    case shift, delete, returnKey

    @ViewBuilder public var image: some View {
        switch self {
        case .shift: KeyGlyph(path: Self.shiftPath).frame(width: 22, height: 22)
        case .delete: KeyGlyph(path: Self.deletePath, box: CGSize(width: 26, height: 22)).frame(width: 25, height: 21)
        case .returnKey: KeyGlyph(path: Self.returnPath, box: CGSize(width: 24, height: 22), lineWidth: 1.9).frame(width: 22, height: 20)
        }
    }

    /// M12 4 4 12h4.5v7h7v-7H20z
    nonisolated static func shiftPath(_ p: inout Path) {
        p.move(to: CGPoint(x: 12, y: 4))
        p.addLine(to: CGPoint(x: 4, y: 12))
        p.addLine(to: CGPoint(x: 8.5, y: 12))
        p.addLine(to: CGPoint(x: 8.5, y: 19))
        p.addLine(to: CGPoint(x: 15.5, y: 19))
        p.addLine(to: CGPoint(x: 15.5, y: 12))
        p.addLine(to: CGPoint(x: 20, y: 12))
        p.closeSubpath()
    }

    /// M8 3h15v16H8l-6-8z, m12 8 6 6m0-6-6 6
    nonisolated static func deletePath(_ p: inout Path) {
        p.move(to: CGPoint(x: 8, y: 3))
        p.addLine(to: CGPoint(x: 23, y: 3))
        p.addLine(to: CGPoint(x: 23, y: 19))
        p.addLine(to: CGPoint(x: 8, y: 19))
        p.addLine(to: CGPoint(x: 2, y: 11))
        p.closeSubpath()
        p.move(to: CGPoint(x: 12, y: 8))
        p.addLine(to: CGPoint(x: 18, y: 14))
        p.move(to: CGPoint(x: 18, y: 8))
        p.addLine(to: CGPoint(x: 12, y: 14))
    }

    /// M20 4v7a3 3 0 0 1-3 3H5, m9 10-4 4 4 4
    nonisolated static func returnPath(_ p: inout Path) {
        p.move(to: CGPoint(x: 20, y: 4))
        p.addLine(to: CGPoint(x: 20, y: 11))
        p.addArc(center: CGPoint(x: 17, y: 11), radius: 3, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        p.addLine(to: CGPoint(x: 5, y: 14))
        p.move(to: CGPoint(x: 9, y: 10))
        p.addLine(to: CGPoint(x: 5, y: 14))
        p.addLine(to: CGPoint(x: 9, y: 18))
    }
}

/// A stroked icon drawn in a fixed box and scaled to its frame, in the current foreground style.
struct KeyGlyph: View {
    var path: @Sendable (inout Path) -> Void
    var box = CGSize(width: 24, height: 24)
    var lineWidth: CGFloat = 1.8

    var body: some View {
        GlyphShape(build: path, box: box)
            .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
            .accessibilityHidden(true)
    }
}

struct GlyphShape: Shape {
    var build: @Sendable (inout Path) -> Void
    var box: CGSize

    func path(in rect: CGRect) -> Path {
        var p = Path()
        build(&p)
        let scale = min(rect.width / box.width, rect.height / box.height)
        return p.applying(CGAffineTransform(scaleX: scale, y: scale)
            .concatenating(CGAffineTransform(translationX: rect.minX, y: rect.minY)))
    }
}
