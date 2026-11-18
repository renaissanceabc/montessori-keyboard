import Foundation

/// Settings live in the App Group's defaults, so the keyboard sees what the app saved.
/// A keyboard without Full Access can read the shared container but not write it.
public struct SettingsStore: Sendable {
    public static let appGroup = "group.com.renaissance.montessorikeyboard"
    static let settingsKey = "keyboardSettings"
    static let fullAccessKey = "fullAccessSeen"

    private let suiteName: String?

    /// `suiteName: nil` uses standard defaults (tests and previews).
    public init(suiteName: String? = SettingsStore.appGroup) {
        self.suiteName = suiteName
    }

    private var defaults: UserDefaults {
        suiteName.flatMap(UserDefaults.init(suiteName:)) ?? .standard
    }

    public func load() -> KeyboardSettings {
        guard let data = defaults.data(forKey: Self.settingsKey),
            let settings = try? JSONDecoder().decode(KeyboardSettings.self, from: data)
        else { return KeyboardSettings() }
        return settings
    }

    public func save(_ settings: KeyboardSettings) {
        guard let data = try? JSONEncoder().encode(settings) else { return }
        defaults.set(data, forKey: Self.settingsKey)
    }

    /// The keyboard records when it last ran with Full Access, so the app can say whether sounds will play.
    public var fullAccessSeen: Bool {
        get { defaults.bool(forKey: Self.fullAccessKey) }
        nonmutating set { defaults.set(newValue, forKey: Self.fullAccessKey) }
    }
}
