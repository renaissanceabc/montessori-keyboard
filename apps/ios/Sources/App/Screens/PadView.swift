import MontessoriUI
import SwiftUI

/// A blank page with the keyboard under it, for writing without opening another app.
struct PadView: View {
    @Environment(AppModel.self) private var model
    @Environment(\.palette) private var palette
    @State private var text: TypedText

    init(initialText: String = "") {
        let typed = TypedText()
        typed.text = initialText
        _text = State(initialValue: typed)
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    (Text(text.text.isEmpty ? "" : text.text) + Text("|").foregroundStyle(palette.vowel))
                        .font(TileFont.writing(34))
                        .foregroundStyle(palette.ink)
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 20)
                        .id("end")
                        .accessibilityLabel(text.text.isEmpty ? "Empty page" : text.text)
                }
                .onChange(of: text.text) { _, _ in proxy.scrollTo("end", anchor: .bottom) }
            }
            .background(palette.card, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .padding(.horizontal, 16)
            .padding(.bottom, 14)

            LiveKeyboard(settings: model.settings, text: text)
        }
        .pageBackground(palette.page)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Clear") { text.text = "" }
                    .disabled(text.text.isEmpty)
            }
        }
    }
}
