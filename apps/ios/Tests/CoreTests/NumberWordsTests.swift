import Testing
@testable import MontessoriCore

struct NumberWordsTests {
    @Test(arguments: [
        (0, "zero"), (7, "seven"), (13, "thirteen"), (40, "forty"), (63, "sixty-three"),
        (100, "one hundred"), (863, "eight hundred sixty-three"), (910, "nine hundred ten"), (999, "nine hundred ninety-nine"),
    ])
    func `spells numbers the American way`(number: Int, words: String) {
        #expect(NumberWords.spell(number) == words)
    }

    @Test func `challenges are three digits with no zeros`() {
        for _ in 0..<200 {
            let n = NumberWords.randomChallenge()
            #expect((111...999).contains(n))
            #expect(!String(n).contains("0"))
        }
    }

    @Test func `the bead stair has a color for one to nine only`() {
        #expect(BeadStair.color(for: 0) == nil)
        #expect(BeadStair.color(for: 10) == nil)
        for n in 1...9 { #expect(BeadStair.color(for: n) != nil) }
    }
}
