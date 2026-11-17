import MontessoriCore
import SwiftUI

/// The whole keyboard: the strip, three rows of letter tiles (or the 123 layer), and the bottom row.
/// The extension hosts it over the text document proxy; the app hosts it over a string in Try it, the preview and the Pad.
public struct KeyboardView: View {
    @Bindable public var model: KeyboardModel
    /// The keyboard extension shows the globe key only when the system asks for it.
    public var showsGlobe: Bool
    /// 0 is the full keyboard; 1 is the Settings preview's compact size, with shorter tiles and tighter rows.
    /// Anything between eases from one to the other, so the preview can settle as the settings scroll.
    public var compact: CGFloat

    public static let tileHeight: CGFloat = 46
    public static let rowSpacing: CGFloat = 11
    /// Space above the first row and below the last, as the canvas draws them.
    public static let topInset: CGFloat = 8
    public static let bottomInset: CGFloat = 4
    public static let stripHeight: CGFloat = 44
    /// The coordinate space keys report their frames and touches in, for the phonogram popup.
    static let space = "keyboard"

    @Environment(\.palette) private var palette
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var width: CGFloat = 375

    public init(model: KeyboardModel, showsGlobe: Bool = false, compact: CGFloat = 0) {
        self.model = model
        self.showsGlobe = showsGlobe
        self.compact = min(max(compact, 0), 1)
    }

    /// The keyboard's height for its settings, so the extension can size itself before it draws.
    public static func height(for settings: KeyboardSettings, compact: CGFloat = 0) -> CGFloat {
        let c = min(max(compact, 0), 1)
        let rows = 4 * tile(at: c) + 3 * rowGap(at: c) + topInset + bottomInset
        return rows + (settings.strip == .off ? 0 : stripHeight)
    }

    /// Compact tiles are 36pt with 7pt between rows, and their letters 22pt: still clearly tiles, about a fifth
    /// shorter, and as wide as ever.
    static func tile(at c: CGFloat) -> CGFloat { tileHeight - 10 * c }
    static func rowGap(at c: CGFloat) -> CGFloat { rowSpacing - 4 * c }
    private var tile: CGFloat { Self.tile(at: compact) }

    public var body: some View {
        VStack(spacing: 0) {
            if model.settings.strip != .off {
                StripView(model: model)
            }
            VStack(spacing: Self.rowGap(at: compact)) {
                switch model.layer {
                case .letters: letterRows
                case .numbers: numberRows
                }
                bottomRow
            }
            .padding(.horizontal, 3)
            .padding(.top, Self.topInset)
            .padding(.bottom, Self.bottomInset)
        }
        .overlay(alignment: .topLeading) {
            if model.trayLetter != nil {
                PhonogramPopup(
                    choices: model.trayChoices,
                    layout: popupLayout,
                    chosen: model.trayChoice,
                    cursive: model.settings.cursive,
                    onPick: { model.pick($0) }
                )
                .transition(
                    reduceMotion
                        ? .opacity
                        : .opacity.combined(with: .scale(scale: 0.96, anchor: UnitPoint(
                            x: (model.trayAnchor.midX - popupLayout.frame.minX) / max(popupLayout.frame.width, 1),
                            y: 1
                        )))
                )
            }
        }
        .background(palette.tray)
        .coordinateSpace(.named(Self.space))
        .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { width = $0 }
        .animation(.easeOut(duration: 0.15), value: model.trayLetter)
    }

    private var popupLayout: PopupLayout {
        PopupLayout(anchor: model.trayAnchor, count: model.trayChoices.count, width: width)
    }

    // MARK: Letters

    private var rows: [[Character]] { model.settings.order.rows }

    private var functionWeight: CGFloat { model.settings.order == .abc ? 1 : 1.45 }

    @ViewBuilder private var letterRows: some View {
        ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
            KeyRow(height: tile) {
                if index == rows.count - 1 {
                    shiftKey.keyWeight(functionWeight)
                }
                ForEach(row, id: \.self) { letter in
                    letterKey(letter)
                }
                if index == rows.count - 1 {
                    deleteKey.keyWeight(functionWeight)
                }
            }
        }
    }

    private func letterKey(_ letter: Character) -> some View {
        LetterKey(
            label: model.label(for: letter),
            color: palette.color(for: LetterKind(letter)),
            cursive: model.settings.cursive,
            fontSize: 26 - 4 * compact,
            lifts: model.trayLetter == nil,
            onTap: { model.tap(letter: letter) },
            onHold: model.settings.phonograms ? { model.hold(letter: letter, at: $0) } : nil,
            onSlide: { model.choose(popupLayout.choice(at: $0, anchor: model.trayAnchor)) },
            onLift: { model.liftFromTray() }
        )
        .accessibilityActions {
            if model.settings.phonograms {
                ForEach(Phonograms.teams(for: Character(model.label(for: letter))), id: \.self) { team in
                    Button(team) { model.tap(team: team) }
                }
            }
        }
    }

    private var shiftKey: some View {
        FunctionKey(
            accessibilityLabel: "Shift",
            dimmed: !model.settings.capitalsWithShift,
            highlighted: model.shifted,
            onTap: { model.tapShift() }
        ) {
            KeyIcon.shift.image
        }
    }

    private var deleteKey: some View {
        FunctionKey(accessibilityLabel: "Delete", repeats: true, onTap: { model.tapDelete() }) {
            KeyIcon.delete.image
        }
    }

    // MARK: Numbers

    @ViewBuilder private var numberRows: some View {
        KeyRow(height: tile) {
            ForEach([1, 2, 3, 4, 5, 6, 7, 8, 9, 0], id: \.self) { digit in
                DigitKey(digit: digit, style: model.settings.numbers) { model.tap(symbol: String(digit)) }
            }
        }
        KeyRow(height: tile) {
            ForEach(Array("-/:;()$&@").map(String.init), id: \.self) { symbol in
                symbolKey(symbol)
            }
        }
        KeyRow(height: tile) {
            ForEach(Array(".,?!'").map(String.init), id: \.self) { symbol in
                symbolKey(symbol).keyWeight(1.4)
            }
            deleteKey.keyWeight(1.45)
        }
    }

    private func symbolKey(_ symbol: String) -> some View {
        KeyButton(accessibilityLabel: symbol, onTap: { model.tap(symbol: symbol) }) { pressed in
            TileFace(pressed: pressed) {
                Text(symbol)
                    .font(TileFont.tile(size: 22, cursive: false))
                    .foregroundStyle(palette.ink)
                    .padding(.bottom, 3)
            }
        }
    }

    // MARK: Bottom row

    private var bottomRow: some View {
        KeyRow(height: tile) {
            FunctionKey(
                accessibilityLabel: model.layer == .letters ? "Numbers" : "Letters",
                onTap: { model.toggleLayer() }
            ) {
                Text(model.layer == .letters ? "123" : "abc")
            }
            .keyWeight(showsGlobe ? 1.5 : 2.3)

            if showsGlobe, let next = model.host.nextKeyboard {
                FunctionKey(accessibilityLabel: "Next keyboard", onTap: next) {
                    Image(systemName: "globe")
                }
                .keyWeight(1.2)
            }

            // Blank, like the canvas's space bar.
            FunctionKey(accessibilityLabel: "Space", onTap: { model.tapSpace() }) {
                Color.clear
            }
            .keyWeight(showsGlobe ? 4.6 : 5)

            FunctionKey(accessibilityLabel: "Return", onTap: { model.tapReturn() }) {
                KeyIcon.returnKey.image
            }
            .keyWeight(showsGlobe ? 2 : 2.3)
        }
    }
}
