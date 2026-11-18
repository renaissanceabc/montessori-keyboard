import CoreText
import SwiftUI
import UIKit

/// Allo for print letters, headings and every other line of text, Playwrite US Trad for cursive. Both are SIL Open
/// Font License fonts, bundled in the app and the keyboard and listed under UIAppFonts.
///
/// The Allo files are Allo Learner: Allo with its learner forms baked in by `scripts/learner-fonts.py`, a
/// single-storey a (ss01), a tailed l (cv03) and a serifed I (cv04), so a child sees the same a on a tile, in the
/// strip and in the app, and never mixes up I and l. Baking them in means no OpenType features at draw time, so
/// text uses `Font.custom(_:size:relativeTo:)` and follows Dynamic Type live, like the system font.
public enum TileFont {
    public static let regular = "AlloLearner-Regular"
    public static let medium = "AlloLearner-Medium"
    public static let semibold = "AlloLearner-SemiBold"
    public static let bold = "AlloLearner-Bold"
    public static let cursive = "PlaywriteUSTrad-Regular"

    /// The bundled font files. Allo Learner is OpenType (.otf), Playwrite TrueType (.ttf).
    static let files: [(name: String, ext: String)] = [
        ("AlloLearner-Regular", "otf"), ("AlloLearner-Medium", "otf"), ("AlloLearner-SemiBold", "otf"),
        ("AlloLearner-Bold", "otf"), ("PlaywriteUSTrad", "ttf"),
    ]

    /// Registers the bundled fonts if UIAppFonts didn't (previews, tests). Safe to call more than once.
    public static func registerIfNeeded(in bundle: Bundle = .main) {
        guard UIFont(name: bold, size: 12) == nil else { return }
        for file in files {
            guard let url = bundle.url(forResource: file.name, withExtension: file.ext) else { continue }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }

    /// A tile letter: bold print, or cursive a little smaller so it fits the same tile. Tiles keep their size, like
    /// the keys on Apple's keyboard, because the keyboard's height is fixed.
    public static func tile(size: CGFloat, cursive: Bool) -> Font {
        cursive ? .custom(Self.cursive, fixedSize: size * 0.78) : .custom(bold, fixedSize: size)
    }

    /// Headings in the app. Scales with Dynamic Type.
    public static func heading(_ size: CGFloat, relativeTo style: Font.TextStyle = .title) -> Font {
        .custom(bold, size: size, relativeTo: style)
    }

    /// Children's writing in the Pad and Try it boxes. Scales with Dynamic Type.
    public static func writing(_ size: CGFloat) -> Font {
        .custom(regular, size: size, relativeTo: .title)
    }

    /// Everything else: labels, rows, captions. Scales with Dynamic Type like the system font it replaces.
    public static func text(
        _ size: CGFloat, weight: Font.Weight = .regular, relativeTo style: Font.TextStyle = .body
    ) -> Font {
        .custom(name(for: weight), size: size, relativeTo: style)
    }

    static func name(for weight: Font.Weight) -> String {
        switch weight {
        case .medium: medium
        case .semibold: semibold
        case .bold, .heavy, .black: bold
        default: regular
        }
    }

    /// Allo Learner for UIKit (the navigation bar), scaled for Dynamic Type. Falls back to the system font if it
    /// isn't registered.
    public static func uiFont(_ name: String, size: CGFloat, relativeTo style: UIFont.TextStyle) -> UIFont {
        let font = UIFont(name: name, size: size) ?? .systemFont(ofSize: size)
        return UIFontMetrics(forTextStyle: style).scaledFont(for: font)
    }
}
