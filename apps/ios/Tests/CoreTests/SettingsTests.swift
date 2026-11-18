import Foundation
import Testing

@testable import MontessoriCore

struct SettingsTests {
    @Test func `defaults match the design`() {
        let s = KeyboardSettings()
        #expect(s.order == .abc)
        #expect(!s.cursive)
        #expect(!s.capitalsWithShift)
        #expect(s.phonograms)
        #expect(s.strip == .rhymes)
        #expect(s.numbers == .beads)
    }

    @Test func `round trips through JSON`() throws {
        var s = KeyboardSettings()
        s.order = .qwerty
        s.cursive = true
        s.strip = .off
        s.numbers = .rods
        let data = try JSONEncoder().encode(s)
        #expect(try JSONDecoder().decode(KeyboardSettings.self, from: data) == s)
    }

    @Test func `missing and unknown keys keep the defaults`() throws {
        let json = Data(#"{"order":"qwerty","strip":"sparkles"}"#.utf8)
        let s = try JSONDecoder().decode(KeyboardSettings.self, from: json)
        #expect(s.order == .qwerty)
        #expect(s.strip == .rhymes)
        #expect(s.letterSounds)
    }

    @Test func `the store saves and loads`() {
        let suite = "test.\(UUID().uuidString)"
        let store = SettingsStore(suiteName: suite)
        var s = KeyboardSettings()
        s.keyClicks = false
        store.save(s)
        #expect(store.load() == s)
        UserDefaults().removePersistentDomain(forName: suite)
    }
}
