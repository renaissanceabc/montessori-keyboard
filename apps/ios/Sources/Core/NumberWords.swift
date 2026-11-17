import Foundation

/// Spells numbers in words, for the grown-ups gate: a child who can type digits can't yet read "eight hundred sixty-three".
public enum NumberWords {
    private static let ones = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine",
                               "ten", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen",
                               "eighteen", "nineteen"]
    private static let tens = ["", "", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"]

    /// 0 through 999 in American English, hyphenated the usual way ("sixty-three").
    public static func spell(_ number: Int) -> String {
        precondition((0...999).contains(number), "the gate only spells 0 to 999")
        if number < 20 { return ones[number] }
        if number < 100 {
            let rest = number % 10
            return tens[number / 10] + (rest == 0 ? "" : "-" + ones[rest])
        }
        let rest = number % 100
        return ones[number / 100] + " hundred" + (rest == 0 ? "" : " " + spell(rest))
    }

    /// A three-digit number with no zeros, so every box gets a digit the child would have to read.
    public static func randomChallenge<G: RandomNumberGenerator>(using generator: inout G) -> Int {
        (0..<3).reduce(0) { total, _ in total * 10 + Int.random(in: 1...9, using: &generator) }
    }

    public static func randomChallenge() -> Int {
        var generator = SystemRandomNumberGenerator()
        return randomChallenge(using: &generator)
    }
}
