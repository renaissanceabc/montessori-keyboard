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
            #if DEBUG
            if let screen = DebugScreen.requested {
                DebugScreenView(screen: screen)
            } else {
                flow
            }
            #else
            flow
            #endif
        }
        .tint(palette.vowel)
        // Every line of text follows Dynamic Type; past the third accessibility size the setup layouts stop fitting.
        .dynamicTypeSize(...DynamicTypeSize.accessibility3)
        .animation(.easeOut(duration: 0.2), value: model.onboarded)
        .animation(.easeOut(duration: 0.2), value: model.unlocked)
    }

    @ViewBuilder private var flow: some View {
        Group {
            if !model.onboarded {
                OnboardingFlow()
            } else if !model.unlocked {
                GateView { model.unlocked = true }
            } else {
                NavigationStack { SettingsView() }
            }
        }
    }
}
