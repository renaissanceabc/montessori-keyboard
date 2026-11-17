import MontessoriCore
import MontessoriUI
import SwiftUI

/// The three steps in iPhone Settings, shared by setup and the Setup guide.
struct SetupSteps: View {
    @Environment(\.palette) private var palette

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            step(1, "Tap Open Settings below", detail: "It opens straight to this app's page.")
            step(2, "Tap Keyboards") {
                MockSettings { MockRow(title: "Keyboards", chevron: true) }
            }
            step(3, "Turn on Montessori Keyboard", detail: "Allow Full Access is optional. It adds letter sounds and key clicks; everything else works without it.") {
                MockSettings {
                    MockRow(title: "Montessori Keyboard", on: true)
                    MockRow(title: "Allow Full Access", on: false)
                }
            }
        }
    }

    private func step(_ n: Int, _ title: String, detail: String? = nil) -> some View {
        step(n, title, detail: detail) { EmptyView() }
    }

    private func step<Mock: View>(_ n: Int, _ title: String, detail: String? = nil, @ViewBuilder mock: () -> Mock) -> some View {
        HStack(alignment: .top, spacing: 14) {
            NumberBadge(n: n)
            VStack(alignment: .leading, spacing: 8) {
                Text(title).font(.system(size: 16, weight: .semibold)).foregroundStyle(palette.ink)
                mock()
                if let detail {
                    Text(detail).font(.system(size: 14)).foregroundStyle(palette.muted)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

/// A step number on a small tile, with its beads.
struct NumberBadge: View {
    var n: Int
    @Environment(\.palette) private var palette

    var body: some View {
        VStack(spacing: 3) {
            Text(String(n)).font(TileFont.tile(size: 18, cursive: false)).foregroundStyle(palette.ink)
            NumberMarks(digit: n, style: .beads)
        }
        .frame(width: 36, height: 44)
        .background(LinearGradient(colors: [palette.tileTop, palette.tileBottom], startPoint: .top, endPoint: .bottom), in: RoundedRectangle(cornerRadius: 7))
        .background(RoundedRectangle(cornerRadius: 7).fill(palette.tileEdge).offset(y: 2))
        .accessibilityLabel("Step \(n)")
    }
}

/// A drawing of iPhone Settings rows, so the grown-up knows what to look for.
struct MockSettings<Content: View>: View {
    @ViewBuilder var content: Content
    @Environment(\.palette) private var palette

    var body: some View {
        VStack(spacing: 0) {
            Group(subviews: content) { rows in
                ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                    if index > 0 { Rectangle().fill(palette.line).frame(height: 1) }
                    row
                }
            }
        }
        .background(palette.card, in: RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(palette.line))
        .accessibilityHidden(true)
    }
}

struct MockRow: View {
    var title: String
    var chevron = false
    var on: Bool?
    @Environment(\.palette) private var palette

    var body: some View {
        HStack {
            Text(title).font(.system(size: 14)).foregroundStyle(palette.ink)
            Spacer()
            if chevron { Image(systemName: "chevron.right").font(.system(size: 12, weight: .semibold)).foregroundStyle(palette.muted) }
            if let on {
                Capsule().fill(on ? palette.success : palette.tileEdge.opacity(0.5))
                    .frame(width: 42, height: 25)
                    .overlay(alignment: on ? .trailing : .leading) {
                        Circle().fill(.white).shadow(radius: 1, y: 1).padding(2)
                    }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }
}

/// A small dot and a line saying whether the keyboard is on yet.
struct KeyboardStatus: View {
    @Environment(AppModel.self) private var model
    @Environment(\.palette) private var palette

    var body: some View {
        HStack(spacing: 8) {
            Circle().fill(model.keyboardEnabled ? palette.success : Color(hex: BeadStair.ten)).frame(width: 8, height: 8)
            Text(model.keyboardEnabled ? "The keyboard is on" : "Waiting for the keyboard")
        }
        .font(.system(size: 14))
        .foregroundStyle(palette.muted)
    }
}

struct SetupView: View {
    var next: () -> Void
    @Environment(AppModel.self) private var model
    @Environment(\.palette) private var palette

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                ScreenHeading(title: "Turn it on", subtitle: "iPhone asks a grown-up to switch on new keyboards in Settings. It takes three taps.")
                SetupSteps()
            }
            .padding(.horizontal, 24)
            .padding(.top, 8)
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                KeyboardStatus()
                if model.keyboardEnabled {
                    PrimaryButton("Next", action: next)
                } else {
                    PrimaryButton("Open Settings") { model.openSettings() }
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(palette.page)
        }
        .pageBackground(palette.page)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) { StepDots(step: 0, of: 2) }
            if !model.keyboardEnabled {
                ToolbarItem(placement: .topBarTrailing) { Button("Skip", action: next) }
            }
        }
    }
}

/// Which setup step this is: a long dash for the current one.
struct StepDots: View {
    var step: Int
    var of: Int
    @Environment(\.palette) private var palette

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<of, id: \.self) { index in
                Capsule()
                    .fill(index == step ? palette.ink : palette.tileEdge.opacity(0.5))
                    .frame(width: index == step ? 22 : 8, height: 8)
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Step \(step + 1) of \(of)")
    }
}
