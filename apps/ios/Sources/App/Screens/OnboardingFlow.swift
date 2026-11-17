import MontessoriUI
import SwiftUI

/// First launch: Welcome, Turn it on, Try it. Done lands in Settings without the gate, since a grown-up is holding the phone.
struct OnboardingFlow: View {
    enum Step: Hashable { case setup, tryIt }

    @Environment(AppModel.self) private var model
    @State private var path: [Step] = []

    var body: some View {
        NavigationStack(path: $path) {
            WelcomeView { path.append(.setup) }
                .navigationDestination(for: Step.self) { step in
                    switch step {
                    case .setup: SetupView { path.append(.tryIt) }
                    case .tryIt: TryItView {
                        model.unlocked = true
                        model.onboarded = true
                    }
                    }
                }
        }
    }
}

struct WelcomeView: View {
    var next: () -> Void
    @Environment(\.palette) private var palette

    var body: some View {
        VStack(spacing: 30) {
            TileTrio().padding(.top, 40)
            ScreenHeading(title: "A keyboard for young learners", subtitle: "A moveable alphabet in the palm of your hands", centered: true)
            VStack(alignment: .leading, spacing: 18) {
                point(icon: AnyView(abIcon), title: "Blue vowels, red consonants", detail: "The same colors as the classroom box.")
                point(icon: AnyView(DecorTile(letter: "m", size: 18)), title: "Big, clear tiles", detail: "Lowercase print, like the moveable alphabet.")
                point(icon: AnyView(Image(systemName: "lock")), title: "Private by design", detail: "No ads, no accounts. Nothing leaves this iPhone.")
                point(icon: AnyView(Image(systemName: "heart")), title: "Free and open source", detail: "Made by Renaissance. The code is public.")
            }
            Spacer(minLength: 0)
            VStack(spacing: 10) {
                Text("Takes about 1 min").font(.system(size: 13.5)).foregroundStyle(palette.muted)
                PrimaryButton("Set up keyboard", action: next)
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 12)
        .pageBackground(palette.page)
        .toolbar(.hidden, for: .navigationBar)
    }

    private var abIcon: some View {
        HStack(spacing: 0) {
            Text("a").foregroundStyle(palette.vowel)
            Text("b").foregroundStyle(palette.consonant)
        }
        .font(TileFont.tile(size: 17, cursive: false))
    }

    private func point(icon: AnyView, title: String, detail: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            icon
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(palette.hint)
                .frame(width: 32, height: 32)
                .background(palette.tray.opacity(0.6), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.system(size: 15, weight: .semibold)).foregroundStyle(palette.ink)
                Text(detail).font(.system(size: 14)).foregroundStyle(palette.muted)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
    }
}
