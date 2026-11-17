import Foundation

/// The order the letter tiles sit in. ABC is how the moveable alphabet box is laid out; QWERTY matches every other keyboard.
public enum KeyOrder: String, Codable, CaseIterable, Sendable {
    case abc
    case qwerty

    /// The three rows of letter tiles, top to bottom.
    public var rows: [[Character]] {
        switch self {
        case .abc: ["abcdefghi", "jklmnopqr", "stuvwxyz"].map(Array.init)
        case .qwerty: ["qwertyuiop", "asdfghjkl", "zxcvbnm"].map(Array.init)
        }
    }
}

/// Blue or red, as on the classroom tiles.
public enum LetterKind: Sendable, Equatable {
    case vowel
    case consonant

    /// Montessori colors the five vowels blue and everything else red, "y" included.
    public init(_ letter: Character) {
        self = "aeiou".contains(letter.lowercased()) ? .vowel : .consonant
    }
}

/// A run of letters with each one's color, for drawing a word in tiles or in the strip.
public struct ColoredLetter: Hashable, Sendable {
    public let character: Character
    public let kind: LetterKind

    public init(_ character: Character) {
        self.character = character
        self.kind = LetterKind(character)
    }

    public static func word(_ text: String) -> [ColoredLetter] {
        text.map(ColoredLetter.init)
    }
}
