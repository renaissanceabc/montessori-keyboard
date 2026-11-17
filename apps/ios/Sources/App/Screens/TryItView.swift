import MontessoriUI
import SwiftUI

/// The last setup step: type in a real text box, with the real keyboard.
struct TryItView: View {
    var done: () -> Void
    @Environment(AppModel.self) private var model
    @Environment(\.palette) private var palette
    @State private var name = ""
    @FocusState private var focused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            ScreenHeading(title: "Try it", subtitle: "Tap the box. If you see Apple's keyboard, tap the globe under it until the wooden tiles appear.")
            VStack(alignment: .leading, spacing: 6) {
                Text("Type your child's name").font(TileFont.text(13)).foregroundStyle(palette.muted)
                TextField("", text: $name)
                    .font(TileFont.writing(28))
                    .foregroundStyle(palette.ink)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .focused($focused)
                    .padding(.horizontal, 14)
                    .frame(height: 54)
                    .background(palette.card, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(focused ? palette.vowel : palette.line, lineWidth: 2)
                    }
                    .accessibilityLabel("Your child's name")
            }
            if model.keyboardEnabled {
                HStack(spacing: 10) {
                    Image(systemName: "checkmark").font(.system(size: 16, weight: .bold))
                    Text("It's on. Hand it over whenever you like.")
                }
                .font(TileFont.text(14))
                .foregroundStyle(palette.successInk)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(palette.successBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
            }
            Spacer(minLength: 0)
            PrimaryButton("Done", action: done)
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .pageBackground(palette.page)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) { StepDots(step: 2, of: 3) }
        }
        .onAppear {
            model.refreshStatus()
            focused = true
        }
    }
}
