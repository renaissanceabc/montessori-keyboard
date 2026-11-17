import Foundation

/// The letter teams a child meets after the single sounds. Holding a tile shows the ones that start with it.
public enum Phonograms {
    public static let byLetter: [Character: [String]] = [
        "a": ["ai", "ay", "ar", "au", "aw"],
        "c": ["ch", "ck"],
        "e": ["ee", "ea", "er", "ew"],
        "g": ["gh"],
        "i": ["igh", "ir", "ie"],
        "k": ["kn"],
        "n": ["ng", "nk"],
        "o": ["oa", "oo", "or", "ou", "ow", "oi", "oy"],
        "p": ["ph"],
        "q": ["qu"],
        "s": ["sh"],
        "t": ["th", "tch"],
        "u": ["ur", "ue"],
        "w": ["wh", "wr"],
    ]

    /// The teams for a tile, or none. Capitals get capitalized teams.
    public static func teams(for letter: Character) -> [String] {
        let lower = Character(letter.lowercased())
        let teams = byLetter[lower] ?? []
        guard letter.isUppercase else { return teams }
        return teams.map { $0.prefix(1).uppercased() + $0.dropFirst() }
    }
}
