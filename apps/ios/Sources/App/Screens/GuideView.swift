import MontessoriUI
import SwiftUI

/// How to turn the keyboard on, switch to it, and what Full Access does.
struct GuideView: View {
    @Environment(AppModel.self) private var model
    @Environment(\.palette) private var palette

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                ScreenHeading(title: "Setup guide")
                KeyboardStatus()
                section("Turn it on") { SetupSteps() }
                section("Switching keyboards") {
                    Text("Tap the globe under the keyboard to swap between this and Apple's. Hold it to pick from a list.")
                }
                section("Full Access") {
                    Text("Optional. It adds letter sounds and key clicks in other apps. Nothing is sent anywhere either way.")
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .safeAreaInset(edge: .bottom) {
            PrimaryButton("Open Settings") { model.openSettings() }
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(palette.page)
        }
        .pageBackground(palette.page)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { model.refreshStatus() }
    }

    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).font(TileFont.heading(20, relativeTo: .title3)).foregroundStyle(palette.ink)
            content().font(.system(size: 15)).foregroundStyle(palette.ink2)
        }
    }
}
