import MontessoriCore
import SwiftUI

extension Color {
    /// A color from 0xRRGGBB, as the design canvas writes them.
    public init(hex: UInt32, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}

/// The two trays: maple in light mode, walnut in dark. Every color the keyboard and the app use comes from here.
public struct Palette: Sendable {
    public let tray: Color
    public let tileTop: Color
    public let tileBottom: Color
    public let tileEdge: Color
    public let tileHighlight: Color
    public let tilePressed: Color
    public let keyTop: Color
    public let keyBottom: Color
    public let keyEdge: Color
    public let keyInk: Color
    public let hint: Color
    public let vowel: Color
    public let consonant: Color
    public let shadow: Color
    /// The lifted tile's shadow, and the phonogram popup's tray and shadow.
    public let liftShadow: Color
    public let popup: Color
    public let popupShadow: Color

    /// App surfaces.
    public let page: Color
    public let card: Color
    public let ink: Color
    public let ink2: Color
    public let muted: Color
    public let line: Color
    public let success: Color
    public let successInk: Color
    public let successBackground: Color

    public static let maple = Palette(
        tray: Color(hex: 0xEADBC0),
        tileTop: Color(hex: 0xF8E7C9),
        tileBottom: Color(hex: 0xF0D8B0),
        tileEdge: Color(hex: 0xCDAA78),
        tileHighlight: .white.opacity(0.7),
        tilePressed: Color(hex: 0xFFF7E8),
        keyTop: Color(hex: 0xEDCFA3),
        keyBottom: Color(hex: 0xE2BD88),
        keyEdge: Color(hex: 0xBF9862),
        keyInk: Color(hex: 0x3A2C1E),
        hint: Color(hex: 0x7A6650),
        vowel: Color(hex: 0x1650B0),
        consonant: Color(hex: 0xB3141A),
        shadow: Color(hex: 0x543412, opacity: 0.22),
        liftShadow: Color(hex: 0x543412, opacity: 0.28),
        popup: Color(hex: 0xD9BF93),
        popupShadow: Color(hex: 0x3C240A, opacity: 0.28),
        page: Color(hex: 0xF6F1E7),
        card: Color(hex: 0xFFFDF8),
        ink: Color(hex: 0x2B2118),
        ink2: Color(hex: 0x4A3C2E),
        muted: Color(hex: 0x6B5B49),
        line: Color(hex: 0x2B2118, opacity: 0.1),
        success: Color(hex: 0x2E8A4A),
        successInk: Color(hex: 0x22562F),
        successBackground: Color(hex: 0xE3EFE3)
    )

    public static let walnut = Palette(
        tray: Color(hex: 0x2A1D15),
        tileTop: Color(hex: 0x6E4C34),
        tileBottom: Color(hex: 0x5C3F2B),
        tileEdge: Color(hex: 0x36241A),
        tileHighlight: Color(hex: 0xFFEBD2, opacity: 0.14),
        tilePressed: Color(hex: 0x8A6648),
        keyTop: Color(hex: 0x4C3526),
        keyBottom: Color(hex: 0x402C1F),
        keyEdge: Color(hex: 0x24170F),
        keyInk: Color(hex: 0xEADFCB),
        hint: Color(hex: 0xA8957C),
        vowel: Color(hex: 0x86BEFF),
        consonant: Color(hex: 0xFF7A6B),
        shadow: .black.opacity(0.45),
        liftShadow: .black.opacity(0.5),
        popup: Color(hex: 0x1E140E),
        popupShadow: .black.opacity(0.55),
        page: Color(hex: 0x14100C),
        card: Color(hex: 0x221A13),
        ink: Color(hex: 0xF1E6D4),
        ink2: Color(hex: 0xD9CBB4),
        muted: Color(hex: 0xB8A88F),
        line: Color(hex: 0xF1E6D4, opacity: 0.1),
        success: Color(hex: 0x3FA65E),
        successInk: Color(hex: 0x9FD8AE),
        successBackground: Color(hex: 0x1C2E20)
    )

    public static func `for`(_ scheme: ColorScheme) -> Palette {
        scheme == .dark ? .walnut : .maple
    }

    public func color(for kind: LetterKind) -> Color {
        kind == .vowel ? vowel : consonant
    }
}

extension EnvironmentValues {
    /// Maple unless a view sets walnut (or uses `schemePalette()`).
    @Entry public var palette: Palette = .maple
}

/// Sets the palette from the color scheme, for a view tree that doesn't choose its own.
public struct SchemePalette: ViewModifier {
    @Environment(\.colorScheme) private var scheme
    public init() {}
    public func body(content: Content) -> some View {
        content.environment(\.palette, Palette.for(scheme))
    }
}

extension View {
    public func schemePalette() -> some View { modifier(SchemePalette()) }
}
