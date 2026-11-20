import MontessoriCore
import MontessoriUI
import SwiftUI
import UIKit

/// The keyboard extension. It hosts the shared SwiftUI keyboard over the text document proxy, reads the
/// settings the app saved in the App Group, and plays sounds only when it has Full Access.
final class KeyboardViewController: UIInputViewController {
    private let store = SettingsStore()
    private var model: KeyboardModel?
    private var host: UIHostingController<AnyView>?
    private var heightConstraint: NSLayoutConstraint?

    override func loadView() {
        // A view that adopts UIInputViewAudioFeedback, so key clicks play.
        let input = KeyboardInputView(frame: .zero, inputViewStyle: .keyboard)
        input.allowsSelfSizing = true
        view = input
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        TileFont.registerIfNeeded(in: Bundle(for: Self.self))

        let model = KeyboardModel(settings: store.load(), host: makeHost())
        self.model = model

        let host = UIHostingController(rootView: AnyView(root(model)))
        host.view.backgroundColor = .clear
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.sizingOptions = []
        addChild(host)
        view.addSubview(host.view)
        NSLayoutConstraint.activate([
            host.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            host.view.topAnchor.constraint(equalTo: view.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        host.didMove(toParent: self)
        self.host = host

        let height = view.heightAnchor.constraint(equalToConstant: KeyboardView.height(for: model.settings))
        height.priority = .required - 1
        height.isActive = true
        heightConstraint = height

        // Redraw in walnut or maple as soon as the host switches between dark and light.
        registerForTraitChanges([UITraitUserInterfaceStyle.self]) { (controller: KeyboardViewController, _) in
            guard let model = controller.model else { return }
            controller.host?.rootView = AnyView(controller.root(model))
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Settings may have changed in the app since the keyboard last showed.
        guard let model else { return }
        let settings = store.load()
        if settings != model.settings { model.settings = settings }
        model.host = makeHost()
        heightConstraint?.constant = KeyboardView.height(for: settings)
        if hasFullAccess { store.fullAccessSeen = true }
        model.refresh()
    }

    override func textDidChange(_ textInput: (any UITextInput)?) {
        super.textDidChange(textInput)
        model?.refresh()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // The globe key comes and goes with the device (Face ID iPhones put it below the keyboard).
        guard let model, let host else { return }
        host.rootView = AnyView(root(model))
    }

    private func root(_ model: KeyboardModel) -> some View {
        KeyboardView(model: model, showsGlobe: needsInputModeSwitchKey, systemBackdrop: true)
            .environment(\.palette, Palette.for(appearanceScheme))
            .environment(\.colorScheme, appearanceScheme)
    }

    /// Match the panel iOS draws behind us: it follows the host's style, which reaches us as our view's trait. A field
    /// that asks for a dark keyboard gets walnut too. (`keyboardAppearance` can say light for a field in a dark app,
    /// which put maple on the dark panel, so it no longer decides light.)
    private var appearanceScheme: ColorScheme {
        if textDocumentProxy.keyboardAppearance == .dark { return .dark }
        return view.traitCollection.userInterfaceStyle == .dark ? .dark : .light
    }

    private func makeHost() -> KeyboardHost {
        let proxy = textDocumentProxy
        let fullAccess = hasFullAccess
        return KeyboardHost(
            insert: { proxy.insertText($0) },
            deleteBackward: { proxy.deleteBackward() },
            textBeforeCursor: { proxy.documentContextBeforeInput ?? "" },
            nextKeyboard: { [weak self] in self?.advanceToNextInputMode() },
            click: { [weak self] in
                guard let self, self.model?.settings.keyClicks ?? true else { return }
                UIDevice.current.playInputClick()
            },
            canSpeak: fullAccess
        )
    }
}

/// Lets `playInputClick` play, honoring the person's keyboard click setting.
final class KeyboardInputView: UIInputView, UIInputViewAudioFeedback {
    var enableInputClicksWhenVisible: Bool { true }
}
