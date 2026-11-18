import Testing

@testable import MontessoriCore

struct LettersTests {
    @Test(arguments: KeyOrder.allCases)
    func `every order has all 26 letters once`(order: KeyOrder) {
        let letters = order.rows.flatMap { $0 }
        #expect(letters.count == 26)
        #expect(Set(letters) == Set("abcdefghijklmnopqrstuvwxyz"))
    }

    @Test func `vowels are blue and y is red`() {
        for vowel in "aeiouAEIOU" { #expect(LetterKind(vowel) == .vowel) }
        for consonant in "bcdyzY" { #expect(LetterKind(consonant) == .consonant) }
    }

    @Test func `phonograms follow the letter's case`() {
        #expect(Phonograms.teams(for: "s") == ["sh"])
        #expect(Phonograms.teams(for: "S") == ["Sh"])
        #expect(Phonograms.teams(for: "b").isEmpty)
    }

    @Test func `every phonogram starts with its letter`() {
        for (letter, teams) in Phonograms.byLetter {
            for team in teams { #expect(team.first == letter) }
        }
    }

    @Test func `every letter and team has a sound`() {
        for letter in "abcdefghijklmnopqrstuvwxyz" { #expect(LetterSounds.ipa(for: String(letter)) != nil) }
        for team in Phonograms.byLetter.values.flatMap({ $0 }) {
            #expect(LetterSounds.ipa(for: team) != nil, "\(team)")
        }
    }
}
