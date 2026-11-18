import LocalAuthentication
import MontessoriCore
import MontessoriUI
import SwiftUI

/// Grown-ups only: type the number spelled out in words, or use Face ID.
struct GateView: View {
    var unlock: () -> Void
    @Environment(\.palette) private var palette
    @State private var challenge = NumberWords.randomChallenge()
    @State private var typed: [Int] = []
    @State private var shake = 0

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 10) {
                Image(systemName: "lock")
                    .font(.largeTitle.weight(.light))
                    .foregroundStyle(palette.icon)
                    .accessibilityHidden(true)
                ScreenHeading(title: "Grown-ups only", subtitle: "Type the number written below.", centered: true)
                Text(NumberWords.spell(challenge))
                    .font(TileFont.text(22, weight: .semibold))
                    .foregroundStyle(palette.ink)
                    .multilineTextAlignment(.center)
                    .padding(.top, 6)
            }
            .padding(.top, 40)

            HStack(spacing: 12) {
                ForEach(0..<3, id: \.self) { index in
                    Text(index < typed.count ? String(typed[index]) : "")
                        .font(TileFont.tile(size: 40, cursive: false))
                        .foregroundStyle(palette.ink)
                        .frame(width: 64, height: 76)
                        .background(palette.field, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .strokeBorder(index == typed.count ? palette.vowel : palette.dot, lineWidth: 2)
                        }
                }
            }
            .modifier(Shake(animatableData: CGFloat(shake)))
            .accessibilityElement()
            .accessibilityLabel(
                typed.isEmpty ? "Nothing typed" : "Typed \(typed.map(String.init).joined(separator: " "))")

            Spacer(minLength: 0)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 3), spacing: 12) {
                ForEach(1...9, id: \.self) { digit in
                    padKey(digit)
                }
                Color.clear.frame(height: 62)
                padKey(0)
                Button {
                    if !typed.isEmpty { typed.removeLast() }
                } label: {
                    KeyIcon.delete.image
                        .scaleEffect(1.2)
                        .foregroundStyle(palette.ink2)
                        .frame(maxWidth: .infinity, minHeight: 62)
                        .contentShape(Rectangle())
                }
                .accessibilityLabel("Delete")
            }

            if let biometry = Biometry.current {
                PrimaryButton(biometry.title, systemImage: biometry.symbol, height: 48) { authenticate() }
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 12)
        .pageBackground(palette.paper)
    }

    private func padKey(_ digit: Int) -> some View {
        Button {
            press(digit)
        } label: {
            VStack(spacing: 4) {
                Text(String(digit)).font(TileFont.tile(size: 28, cursive: false))
                BeadRow(digit: digit)
            }
            .foregroundStyle(palette.ink)
            .frame(maxWidth: .infinity, minHeight: 62)
        }
        .buttonStyle(PadKeyStyle())
        .accessibilityLabel(String(digit))
    }

    private func press(_ digit: Int) {
        guard typed.count < 3 else { return }
        typed.append(digit)
        guard typed.count == 3 else { return }
        let number = typed.reduce(0) { $0 * 10 + $1 }
        if number == challenge {
            unlock()
        } else {
            withAnimation(.easeOut(duration: 0.35)) { shake += 1 }
            Task {
                try? await Task.sleep(for: .milliseconds(400))
                typed = []
                challenge = NumberWords.randomChallenge()
            }
        }
    }

    private func authenticate() {
        Task {
            let context = LAContext()
            let ok =
                (try? await context.evaluatePolicy(
                    .deviceOwnerAuthentication, localizedReason: "Open Montessori Keyboard's settings")) ?? false
            if ok { unlock() }
        }
    }
}

/// Face ID, Touch ID or the passcode, whichever this device has.
struct Biometry {
    var title: String
    var symbol: String

    static var current: Biometry? {
        let context = LAContext()
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil) else { return nil }
        switch context.biometryType {
        case .faceID: return Biometry(title: "Use Face ID", symbol: "faceid")
        case .touchID: return Biometry(title: "Use Touch ID", symbol: "touchid")
        case .opticID: return Biometry(title: "Use Optic ID", symbol: "opticid")
        default: return Biometry(title: "Use passcode", symbol: "lock")
        }
    }
}

/// A gate key: a tile that sinks onto its edge when pressed, like the keyboard's.
struct PadKeyStyle: ButtonStyle {
    @Environment(\.palette) private var palette

    func makeBody(configuration: Configuration) -> some View {
        let shape = RoundedRectangle(cornerRadius: 10, style: .continuous)
        let pressed = configuration.isPressed
        configuration.label
            .padding(.bottom, 4)
            .background(
                shape.fill(
                    LinearGradient(colors: [palette.tileTop, palette.tileBottom], startPoint: .top, endPoint: .bottom))
            )
            .background(shape.fill(palette.tileEdge).offset(y: pressed ? 0 : 2))
            .background(
                shape.fill(palette.tileEdge).shadow(
                    color: palette.shadow, radius: pressed ? 1 : 2.5, y: pressed ? 1 : 3)
            )
            .offset(y: pressed ? 2 : 0)
            .animation(pressed ? nil : .easeOut(duration: 0.08), value: pressed)
    }
}

/// A short side-to-side shake for a wrong answer.
struct Shake: GeometryEffect {
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: 8 * sin(animatableData * .pi * 4), y: 0))
    }
}
