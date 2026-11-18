import MontessoriUI
import SwiftUI

/// How to turn the keyboard on, switch to it, and what Full Access does.
struct GuideView: View {
    @Environment(AppModel.self) private var model
    @Environment(\.palette) private var palette

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if model.keyboardEnabled {
                    OnNotice(text: "The keyboard is on")
                } else {
                    KeyboardStatus()
                }
                section("Turn it on") { SetupSteps(compact: true).padding(.vertical, 6).padding(.horizontal, 2) }
                section("Switching keyboards") {
                    card("Tap the globe under the keyboard to swap between this and Apple's. Hold it to pick from a list.")
                }
                section("Full Access") {
                    card("Optional. It adds letter sounds and key clicks in other apps. Nothing is sent anywhere either way.")
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .safeAreaInset(edge: .bottom) {
            PrimaryButton("Open Settings") { model.openSettings() }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(palette.page)
        }
        .pageBackground(palette.page)
        .navigationTitle("Setup guide")
        .navigationBarTitleDisplayMode(.large)
        .onAppear { model.refreshStatus() }
    }

    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(TileFont.text(13, relativeTo: .footnote))
                .foregroundStyle(palette.muted)
                .padding(.horizontal, 4)
                .accessibilityAddTraits(.isHeader)
            content()
        }
    }

    private func card(_ text: String) -> some View {
        Text(text)
            .font(TileFont.text(14))
            .foregroundStyle(palette.ink2)
            .lineSpacing(2)
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(palette.card, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            .overlay { RoundedRectangle(cornerRadius: 12, style: .continuous).strokeBorder(palette.line, lineWidth: 1) }
    }
}
