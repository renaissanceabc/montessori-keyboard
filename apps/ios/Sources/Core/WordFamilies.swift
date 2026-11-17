import Foundation

/// Rhyming words that share an ending ("-at": bat, cat, hat). The strip offers them to swap in for the word just typed.
public enum WordFamilies {
    public static let families: [String: [String]] = [
        "ab": ["cab", "dab", "jab", "lab", "tab"],
        "ad": ["bad", "dad", "had", "mad", "pad", "sad"],
        "ag": ["bag", "rag", "tag", "wag"],
        "am": ["ham", "jam", "ram", "yam"],
        "an": ["can", "fan", "man", "pan", "ran", "van"],
        "ap": ["cap", "lap", "map", "nap", "tap"],
        "at": ["bat", "cat", "hat", "mat", "rat", "sat"],
        "ed": ["bed", "fed", "led", "red", "wed"],
        "eg": ["beg", "keg", "leg", "peg"],
        "en": ["hen", "men", "pen", "ten"],
        "et": ["jet", "net", "pet", "vet", "wet"],
        "ib": ["bib", "fib", "rib"],
        "id": ["bid", "did", "hid", "kid", "lid"],
        "ig": ["big", "dig", "fig", "pig", "wig"],
        "in": ["bin", "fin", "pin", "tin", "win"],
        "ip": ["dip", "hip", "lip", "rip", "sip", "tip", "zip"],
        "it": ["bit", "fit", "hit", "kit", "pit", "sit"],
        "ob": ["cob", "job", "mob", "rob", "sob"],
        "og": ["dog", "fog", "hog", "jog", "log"],
        "op": ["hop", "mop", "pop", "top"],
        "ot": ["cot", "dot", "got", "hot", "lot", "pot"],
        "ug": ["bug", "dug", "hug", "jug", "mug", "rug"],
        "un": ["bun", "fun", "run", "sun"],
        "ut": ["cut", "hut", "nut", "rut"],
    ]

    /// The ending the word belongs to, if it's in a family. "Cat" and "cat" both give "at".
    public static func family(of word: String) -> String? {
        let lower = word.lowercased()
        guard lower.count >= 2 else { return nil }
        return families.keys.filter { lower.hasSuffix($0) }.max { $0.count < $1.count }
    }

    /// Other words in the family, without the word itself. Empty when it has no family.
    public static func rhymes(for word: String, limit: Int = 5) -> [String] {
        guard let family = family(of: word) else { return [] }
        let lower = word.lowercased()
        return Array(families[family, default: []].filter { $0 != lower }.prefix(limit))
    }
}

/// The word just before the cursor, and whether a space follows it.
public struct TrailingWord: Equatable, Sendable {
    public let word: String
    public let trailingSpaces: Int

    /// Reads the last run of letters in the text before the cursor, allowing spaces after it.
    public init?(before text: String) {
        let trimmed = text.reversed().prefix { $0 == " " }
        let rest = text.dropLast(trimmed.count)
        let letters = rest.reversed().prefix { $0.isLetter }
        guard !letters.isEmpty else { return nil }
        word = String(letters.reversed())
        trailingSpaces = trimmed.count
    }

    /// How many characters to delete to remove the word (and the spaces after it).
    public var deleteCount: Int { word.count + trailingSpaces }
}
