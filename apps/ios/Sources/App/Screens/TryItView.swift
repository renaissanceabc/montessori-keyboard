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
            ScreenHeading(
                title: "Try it",
                subtitle:
                    "Tap the box. If you see Apple's keyboard, tap the globe under it until the wooden tiles appear.")
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
                    .background(palette.field, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(focused ? palette.vowel : palette.line, lineWidth: 2)
                    }
                    .accessibilityLabel("Your child's name")
            }
            if model.keyboardEnabled {
                OnNotice(text: "It's on. Hand it over whenever you like.")
            }
            Spacer(minLength: 0)
            PrimaryButton("Done", height: 46, action: done)
        }
        .padding(.horizontal, 24)
        .padding(.top, 8)
        .padding(.bottom, 12)
        .pageBackground(palette.paper)
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
