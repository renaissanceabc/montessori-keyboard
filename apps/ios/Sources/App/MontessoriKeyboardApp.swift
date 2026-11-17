import MontessoriUI
import SwiftUI
import UIKit

@main
struct MontessoriKeyboardApp: App {
    @State private var model = AppModel()
    @Environment(\.scenePhase) private var scenePhase

    init() {
        TileFont.registerIfNeeded()
        Self.styleNavigationBars()
    }

    /// Native navigation bars with their titles in Allo, so every page title matches the rest of the app.
    private static func styleNavigationBars() {
        // Since iOS 15 the bar draws from its appearance objects, which ignore the proxy's own title attributes, so
        // Allo goes into each of them. The scroll-edge one stays transparent, as the system's is.
        let large = allo(TileFont.bold, size: 34, style: .largeTitle)
        let inline = allo(TileFont.semibold, size: 17, style: .headline)
        func styled(_ appearance: UINavigationBarAppearance) -> UINavigationBarAppearance {
            appearance.largeTitleTextAttributes[.font] = large
            appearance.titleTextAttributes[.font] = inline
            return appearance
        }
        let standard = UINavigationBarAppearance()
        standard.configureWithDefaultBackground()
        let edge = UINavigationBarAppearance()
        edge.configureWithTransparentBackground()
        let bar = UINavigationBar.appearance()
        bar.standardAppearance = styled(standard)
        bar.compactAppearance = styled(standard.copy())
        bar.scrollEdgeAppearance = styled(edge)
        bar.compactScrollEdgeAppearance = styled(edge.copy())
    }

    private static func allo(_ name: String, size: CGFloat, style: UIFont.TextStyle) -> UIFont {
        let font = UIFont(name: name, size: size) ?? .systemFont(ofSize: size, weight: .bold)
        return UIFontMetrics(forTextStyle: style).scaledFont(for: font)
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
