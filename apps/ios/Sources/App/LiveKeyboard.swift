import MontessoriCore
import MontessoriUI
import Observation
import SwiftUI

/// Text typed on the in-app keyboard (the Settings preview and the Pad).
@MainActor
@Observable
final class TypedText {
    var text = ""
    /// Keeps only the end, for the preview, where nobody reads it back.
    var limit: Int?
    @ObservationIgnored var clicks = true

    init(limit: Int? = nil) {
        self.limit = limit
    }

    var host: KeyboardHost {
        KeyboardHost(
            insert: { [weak self] in
                guard let self else { return }
                text += $0
                if let limit, text.count > limit { text = String(text.suffix(limit)) }
            },
            deleteBackward: { [weak self] in
                guard let self, !text.isEmpty else { return }
                text.removeLast()
            },
            textBeforeCursor: { [weak self] in self?.text ?? "" },
            click: { [weak self] in if self?.clicks == true { AppClick.play() } }
        )
    }
}

/// The real keyboard view, typing into a `TypedText` with the app's settings.
struct LiveKeyboard: View {
    var settings: KeyboardSettings
    var text: TypedText
    @State private var model: KeyboardModel?

    var body: some View {
        Group {
            if let model {
                KeyboardView(model: model)
            } else {
                Color.clear.frame(height: KeyboardView.height(for: settings))
            }
        }
        .onAppear {
            text.clicks = settings.keyClicks
            if model == nil { model = KeyboardModel(settings: settings, host: text.host) }
        }
        .onChange(of: settings) { _, new in
            text.clicks = new.keyClicks
            model?.settings = new
        }
        .onChange(of: text.text) { _, _ in model?.refresh() }
    }
}

extension StripMode {
    var title: String {
        switch self {
        case .rhymes: "Rhymes"
        case .letters: "Word mat"
        case .off: "Quiet"
        }
    }
}

extension NumberStyle {
    var title: String {
        switch self {
        case .beads: "Beads"
        case .rods: "Rods"
        case .plain: "Plain"
        }
    }
}
