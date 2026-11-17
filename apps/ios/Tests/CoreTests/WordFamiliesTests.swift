import Testing
@testable import MontessoriCore

struct WordFamiliesTests {
    @Test func `rhymes leave out the word itself`() {
        let rhymes = WordFamilies.rhymes(for: "cat")
        #expect(!rhymes.contains("cat"))
        #expect(rhymes.allSatisfy { $0.hasSuffix("at") })
        #expect(rhymes.count == 5)
    }

    @Test func `capitals still find the family`() {
        #expect(WordFamilies.family(of: "Sun") == "un")
    }

    @Test func `a word outside every family gets nothing`() {
        #expect(WordFamilies.rhymes(for: "fish").isEmpty)
        #expect(WordFamilies.rhymes(for: "a").isEmpty)
    }

    @Test func `every family word ends in its family`() {
        for (family, words) in WordFamilies.families {
            for word in words { #expect(word.hasSuffix(family)) }
        }
    }

    @Test(arguments: [
        ("the cat", "cat", 0),
        ("the cat ", "cat", 1),
        ("hi, sun  ", "sun", 2),
    ])
    func `the trailing word is the last letters before the cursor`(text: String, word: String, spaces: Int) throws {
        let trailing = try #require(TrailingWord(before: text))
        #expect(trailing.word == word)
        #expect(trailing.trailingSpaces == spaces)
        #expect(trailing.deleteCount == word.count + spaces)
    }

    @Test func `no word before punctuation or nothing`() {
        #expect(TrailingWord(before: "") == nil)
        #expect(TrailingWord(before: "cat.") == nil)
        #expect(TrailingWord(before: "   ") == nil)
    }
}
