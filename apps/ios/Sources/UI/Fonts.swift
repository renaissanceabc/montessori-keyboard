import CoreText
import SwiftUI
import UIKit

/// Andika for print letters and headings, Playwrite US Trad for cursive. Both are SIL Open Font License fonts,
/// bundled in the app and the keyboard and listed under UIAppFonts.
public enum TileFont {
    public static let regular = "Andika"
    public static let bold = "Andika-Bold"
    public static let cursive = "PlaywriteUSTrad-Regular"

    /// Registers the bundled fonts if UIAppFonts didn't (previews, tests). Safe to call more than once.
    public static func registerIfNeeded(in bundle: Bundle = .main) {
        guard UIFont(name: bold, size: 12) == nil else { return }
        for name in ["Andika-Regular", "Andika-Bold", "PlaywriteUSTrad"] {
            guard let url = bundle.url(forResource: name, withExtension: "ttf") else { continue }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }

    /// A tile letter: bold print, or cursive a little smaller so it fits the same tile.
    public static func tile(size: CGFloat, cursive: Bool) -> Font {
        cursive ? .custom(Self.cursive, fixedSize: size * 0.78) : .custom(bold, fixedSize: size)
    }

    /// Headings in the app. Scales with Dynamic Type.
    public static func heading(_ size: CGFloat, relativeTo style: Font.TextStyle = .title) -> Font {
        .custom(bold, size: size, relativeTo: style)
    }

    /// Children's writing in the Pad and Try it boxes.
    public static func writing(_ size: CGFloat) -> Font {
        .custom(regular, size: size, relativeTo: .title)
    }
}
