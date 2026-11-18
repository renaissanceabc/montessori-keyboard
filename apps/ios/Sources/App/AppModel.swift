import MontessoriCore
import Observation
import SwiftUI
import UIKit

/// The app's state: the settings it shares with the keyboard, whether setup is done, and whether the keyboard is on.
@MainActor
@Observable
final class AppModel {
    static let keyboardBundleID = "com.renaissance.montessorikeyboard.keyboard"

    @ObservationIgnored private let store: SettingsStore
    @ObservationIgnored private let defaults: UserDefaults

    var settings: KeyboardSettings {
        didSet { if settings != oldValue { store.save(settings) } }
    }

    var onboarded: Bool {
        didSet { defaults.set(onboarded, forKey: "onboarded") }
    }

    /// Past the grown-ups gate in this visit.
    var unlocked = false
    private(set) var keyboardEnabled = false
    private(set) var fullAccessSeen = false

    init(store: SettingsStore = SettingsStore(), defaults: UserDefaults = .standard) {
        self.store = store
        self.defaults = defaults
        settings = store.load()
        onboarded = defaults.bool(forKey: "onboarded")
        refreshStatus()
    }

    /// Re-checks the keyboard after a trip to Settings.
    func refreshStatus() {
        keyboardEnabled = Self.isKeyboardEnabled()
        fullAccessSeen = store.fullAccessSeen
    }

    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    /// Whether Montessori Keyboard is in the person's list of keyboards.
    private static func isKeyboardEnabled() -> Bool {
        if let keyboards = UserDefaults.standard.array(forKey: "AppleKeyboards") as? [String],
            keyboards.contains(keyboardBundleID)
        {
            return true
        }
        let selector = NSSelectorFromString("identifier")
        return UITextInputMode.activeInputModes.contains { mode in
            guard mode.responds(to: selector) else { return false }
            return (mode.value(forKey: "identifier") as? String) == keyboardBundleID
        }
    }

    var statusLine: String {
        switch (keyboardEnabled, fullAccessSeen) {
        case (false, _): "Keyboard off"
        case (true, true): "Keyboard on · Full Access on"
        case (true, false): "Keyboard on · Full Access off"
        }
    }
}
