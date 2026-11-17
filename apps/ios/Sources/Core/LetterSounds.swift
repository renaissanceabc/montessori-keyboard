import Foundation

/// The sound each letter makes, as IPA for the speech synthesizer. Montessori children learn sounds before names:
/// "a" is the "a" in "apple", not "ay".
public enum LetterSounds {
    public static let ipa: [Character: String] = [
        "a": "æ", "b": "bə", "c": "kə", "d": "də", "e": "ɛ", "f": "fff", "g": "gə", "h": "hə",
        "i": "ɪ", "j": "dʒə", "k": "kə", "l": "lll", "m": "mmm", "n": "nnn", "o": "ɒ", "p": "pə",
        "q": "kwə", "r": "rrr", "s": "sss", "t": "tə", "u": "ʌ", "v": "vvv", "w": "wə", "x": "ks",
        "y": "jə", "z": "zzz",
    ]

    /// IPA for phonograms a child can long-press.
    public static let teams: [String: String] = [
        "sh": "ʃʃʃ", "ch": "tʃ", "th": "θθθ", "wh": "wə", "ck": "kə", "ng": "ŋ", "nk": "ŋk", "qu": "kwə",
        "ph": "fff", "kn": "nnn", "wr": "rrr", "gh": "gə", "tch": "tʃ",
        "ai": "eɪ", "ay": "eɪ", "ar": "ɑr", "au": "ɔ", "aw": "ɔ", "ee": "iː", "ea": "iː", "er": "ɜr",
        "ew": "uː", "igh": "aɪ", "ir": "ɜr", "ie": "aɪ", "oa": "oʊ", "oo": "uː", "or": "ɔr", "ou": "aʊ",
        "ow": "aʊ", "oi": "ɔɪ", "oy": "ɔɪ", "ur": "ɜr", "ue": "uː",
    ]

    /// IPA for what was typed, or nil when it isn't a letter or a known team.
    public static func ipa(for text: String) -> String? {
        let lower = text.lowercased()
        if lower.count == 1, let ch = lower.first { return ipa[ch] }
        return teams[lower]
    }
}
