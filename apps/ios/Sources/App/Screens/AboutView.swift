import MontessoriUI
import SwiftUI

/// Version, source code, license, privacy, fonts and feedback.
struct AboutView: View {
    @Environment(\.palette) private var palette

    static let repo = URL(string: "https://github.com/renaissanceabc/montessori-keyboard")!

    private var version: String {
        let info = Bundle.main.infoDictionary
        return info?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    TileTrio(size: 52)
                    Text("Montessori Keyboard").font(TileFont.heading(26)).foregroundStyle(palette.ink)
                    Text("Version \(version) · Free and open source").font(TileFont.text(14)).foregroundStyle(palette.muted)
                }
                .padding(.top, 12)

                SettingsGroup(title: "Open source") {
                    link("Source code", value: "GitHub", url: Self.repo)
                    link("License", value: "MIT", url: Self.repo.appending(path: "blob/main/LICENSE"))
                }
                SettingsGroup(title: "Privacy") {
                    SettingsRow(title: "Data collected") {
                        Text("None").foregroundStyle(palette.muted)
                    }
                }
                SettingsGroup(title: "Fonts", footer: "Both under the SIL Open Font License.") {
                    link("Allo", value: "Josh Puckett", url: URL(string: "https://allo.joshpuckett.me")!)
                    link("Playwrite US Trad", value: "TypeTogether", url: URL(string: "https://github.com/TypeTogether/Playwrite")!)
                }
                SettingsGroup(title: "Feedback") {
                    link("Report a problem", value: "GitHub", url: Self.repo.appending(path: "issues"))
                }
                Text("Made by Renaissance, after Maria Montessori's moveable alphabet. Links open in Safari.")
                    .font(TileFont.text(13))
                    .foregroundStyle(palette.muted)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 28)
        }
        .pageBackground(palette.page)
        .navigationBarTitleDisplayMode(.inline)
    }

    private func link(_ title: String, value: String, url: URL) -> some View {
        Link(destination: url) {
            SettingsRow(title: title) {
                HStack(spacing: 6) {
                    Text(value).foregroundStyle(palette.muted)
                    Image(systemName: "arrow.up.right").font(.caption.weight(.semibold)).foregroundStyle(palette.muted)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
