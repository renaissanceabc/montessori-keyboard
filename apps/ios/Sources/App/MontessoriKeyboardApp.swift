import MontessoriUI
import SwiftUI

@main
struct MontessoriKeyboardApp: App {
    @State private var model = AppModel()
    @Environment(\.scenePhase) private var scenePhase

    init() {
        TileFont.registerIfNeeded()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(model)
                .schemePalette()
                .onChange(of: scenePhase) { _, phase in
                    switch phase {
                    case .active: model.refreshStatus()
                    // Settings lock again whenever the app leaves the screen, so a child can't wander in later.
                    case .background: model.unlocked = false
                    default: break
                    }
                }
        }
    }
}

/// Setup on first launch; after that, Settings behind the grown-ups gate.
struct RootView: View {
    @Environment(AppModel.self) private var model
    @Environment(\.palette) private var palette

    var body: some View {
        Group {
            if !model.onboarded {
                OnboardingFlow()
            } else if !model.unlocked {
                GateView { model.unlocked = true }
            } else {
                NavigationStack { SettingsView() }
            }
        }
        .tint(palette.vowel)
        .animation(.easeOut(duration: 0.2), value: model.onboarded)
        .animation(.easeOut(duration: 0.2), value: model.unlocked)
    }
}
