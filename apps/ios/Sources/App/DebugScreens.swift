#if DEBUG
import MontessoriUI
import SwiftUI

/// Opens one screen straight away, for screenshots: `-screen settings` (and `-padText "the cat"` for the Pad).
/// Debug builds only.
enum DebugScreen: String {
    case welcome, preferences, setup, tryit, gate, settings, pad, strip, numbers, guide, about

    static var requested: DebugScreen? {
        let args = ProcessInfo.processInfo.arguments
        guard let index = args.firstIndex(of: "-screen"), args.indices.contains(index + 1) else { return nil }
        return DebugScreen(rawValue: args[index + 1])
    }

    static var padText: String {
        let args = ProcessInfo.processInfo.arguments
        guard let index = args.firstIndex(of: "-padText"), args.indices.contains(index + 1) else { return "" }
        return args[index + 1]
    }
}

struct DebugScreenView: View {
    var screen: DebugScreen

    var body: some View {
        switch screen {
        case .welcome: NavigationStack { WelcomeView {} }
        case .preferences: NavigationStack { PreferencesView {} }
        case .setup: NavigationStack { SetupView {} }
        case .tryit: NavigationStack { TryItView {} }
        case .gate: GateView {}
        case .settings: NavigationStack { SettingsView() }
        case .pad: NavigationStack { PadView(initialText: DebugScreen.padText) }
        case .strip: NavigationStack { StripOptionsView() }
        case .numbers: NavigationStack { NumbersOptionsView() }
        case .guide: NavigationStack { GuideView() }
        case .about: NavigationStack { AboutView() }
        }
    }
}
#endif
