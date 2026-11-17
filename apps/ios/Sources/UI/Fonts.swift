import CoreText
import SwiftUI
import UIKit

/// Allo for print letters, headings and every other line of text, Playwrite US Trad for cursive. Both are SIL Open
/// Font License fonts, bundled in the app and the keyboard and listed under UIAppFonts.
///
/// Allo is always drawn with its learner forms on: a single-storey a (ss01), a tailed l (cv03) and a serifed I
/// (cv04), so a child sees the same a on a tile, in the strip and in the app, and never mixes up I and l.
public enum TileFont {
    public static let regular = "Allo-Regular"
    public static let medium = "Allo-Medium"
    public static let semibold = "Allo-SemiBold"
    public static let bold = "Allo-Bold"
    public static let cursive = "PlaywriteUSTrad-Regular"

    /// The bundled font files. Allo is OpenType (.otf), Playwrite TrueType (.ttf).
    static let files: [(name: String, ext: String)] = [
        ("Allo-Regular", "otf"), ("Allo-Medium", "otf"), ("Allo-SemiBold", "otf"), ("Allo-Bold", "otf"),
        ("PlaywriteUSTrad", "ttf"),
    ]

    /// Allo's stylistic set and character variants for learners, as OpenType feature tags.
    static let learnerFeatures = ["ss01", "cv03", "cv04"]

    /// Registers the bundled fonts if UIAppFonts didn't (previews, tests). Safe to call more than once.
    public static func registerIfNeeded(in bundle: Bundle = .main) {
        guard UIFont(name: bold, size: 12) == nil else { return }
        for file in files {
            guard let url = bundle.url(forResource: file.name, withExtension: file.ext) else { continue }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }

    /// A tile letter: bold print, or cursive a little smaller so it fits the same tile.
    public static func tile(size: CGFloat, cursive: Bool) -> Font {
        cursive ? .custom(Self.cursive, fixedSize: size * 0.78) : Font(allo(bold, size: size))
    }

    /// Headings in the app. Scales with Dynamic Type.
    public static func heading(_ size: CGFloat, relativeTo style: Font.TextStyle = .title) -> Font {
        scaled(bold, size: size, style: style)
    }

    /// Children's writing in the Pad and Try it boxes.
    public static func writing(_ size: CGFloat) -> Font {
        scaled(regular, size: size, style: .title)
    }

    /// Everything else: labels, rows, captions. Scales with Dynamic Type like the system font it replaces.
    public static func text(_ size: CGFloat, weight: Font.Weight = .regular, relativeTo style: Font.TextStyle = .body) -> Font {
        scaled(name(for: weight), size: size, style: style)
    }

    static func name(for weight: Font.Weight) -> String {
        switch weight {
        case .medium: medium
        case .semibold: semibold
        case .bold, .heavy, .black: bold
        default: regular
        }
    }

    /// Allo at a fixed size with the learner forms on. Falls back to the system font if Allo isn't registered.
    static func allo(_ name: String, size: CGFloat) -> UIFont {
        let settings: [[UIFontDescriptor.FeatureKey: Any]] = learnerFeatures.map { tag in
            [openTypeTag: tag, openTypeValue: 1]
        }
        let descriptor = UIFontDescriptor(name: name, size: size).addingAttributes([.featureSettings: settings])
        guard UIFont(name: name, size: size) != nil else { return .systemFont(ofSize: size) }
        return UIFont(descriptor: descriptor, size: size)
    }

    private static let openTypeTag = UIFontDescriptor.FeatureKey(rawValue: kCTFontOpenTypeFeatureTag as String)
    private static let openTypeValue = UIFontDescriptor.FeatureKey(rawValue: kCTFontOpenTypeFeatureValue as String)

    /// A custom UIFont can't carry `relativeTo:`, so the Dynamic Type size is applied when the view draws.
    static func scaled(_ name: String, size: CGFloat, style: Font.TextStyle) -> Font {
        Font(UIFontMetrics(forTextStyle: style.uiTextStyle).scaledFont(for: allo(name, size: size)))
    }
}

extension Font.TextStyle {
    var uiTextStyle: UIFont.TextStyle {
        switch self {
        case .largeTitle: .largeTitle
        case .title: .title1
        case .title2: .title2
        case .title3: .title3
        case .headline: .headline
        case .subheadline: .subheadline
        case .callout: .callout
        case .footnote: .footnote
        case .caption: .caption1
        case .caption2: .caption2
        default: .body
        }
    }
}
