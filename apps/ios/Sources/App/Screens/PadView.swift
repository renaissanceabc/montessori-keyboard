import MontessoriUI
import SwiftUI

/// A blank page with the keyboard under it, for writing without opening another app.
struct PadView: View {
    @Environment(AppModel.self) private var model
    @Environment(\.palette) private var palette
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
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
                    // The caret blinks once a second, like the canvas's; it holds still with Reduce Motion.
                    TimelineView(.periodic(from: .now, by: 0.5)) { context in
                        let on = reduceMotion || Int(context.date.timeIntervalSinceReferenceDate * 2).isMultiple(of: 2)
                        Text("\(text.text)\(Text("|").foregroundStyle(palette.vowel.opacity(on ? 1 : 0)))")
                    }
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
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(palette.card)
                    .shadow(color: palette.separator, radius: 1.5, y: 1)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 14)

            LiveKeyboard(settings: model.settings, text: text)
        }
        .pageBackground(palette.page)
        .navigationTitle("Pad")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Clear") { text.text = "" }
                    .disabled(text.text.isEmpty)
            }
        }
    }
}
