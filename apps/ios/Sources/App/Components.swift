import AudioToolbox
import MontessoriCore
import MontessoriUI
import SwiftUI

/// The dark, full-width button at the bottom of setup screens.
struct PrimaryButton: View {
    var title: String
    var systemImage: String?
    var action: () -> Void
    @Environment(\.palette) private var palette

    init(_ title: String, systemImage: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let systemImage { Image(systemName: systemImage) }
                Text(title)
            }
            .font(TileFont.text(17, weight: .semibold))
            .frame(maxWidth: .infinity, minHeight: 52)
            .foregroundStyle(palette.page)
            .background(palette.ink, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

/// A screen's big Allo title and the line under it.
struct ScreenHeading: View {
    var title: String
    var subtitle: String?
    var centered = false
    @Environment(\.palette) private var palette

    var body: some View {
        VStack(alignment: centered ? .center : .leading, spacing: 8) {
            Text(title)
                .font(TileFont.heading(30))
                .foregroundStyle(palette.ink)
                .accessibilityAddTraits(.isHeader)
            if let subtitle {
                Text(subtitle)
                    .font(TileFont.text(15))
                    .foregroundStyle(palette.ink2)
                    .lineSpacing(2)
            }
        }
        .multilineTextAlignment(centered ? .center : .leading)
        .frame(maxWidth: .infinity, alignment: centered ? .center : .leading)
    }
}

/// A single tile drawn for decoration (Welcome, About, the icon).
struct DecorTile: View {
    var letter: String
    var size: CGFloat = 70
    @Environment(\.palette) private var palette

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: size * 0.16, style: .continuous)
        Text(letter)
            .font(TileFont.tile(size: size * 0.66, cursive: false))
            .foregroundStyle(palette.color(for: LetterKind(Character(letter))))
            .padding(.bottom, size * 0.08)
            .frame(width: size, height: size * 1.17)
            .background(shape.fill(LinearGradient(colors: [palette.tileTop, palette.tileBottom], startPoint: .top, endPoint: .bottom)))
            .background(shape.fill(palette.tileEdge).offset(y: 3).shadow(color: palette.shadow, radius: 5, y: 6))
    }
}

/// a, b, c tiles, slightly askew, like they were just set down.
struct TileTrio: View {
    var size: CGFloat = 70

    var body: some View {
        HStack(spacing: size * 0.14) {
            DecorTile(letter: "a", size: size).rotationEffect(.degrees(-4))
            DecorTile(letter: "b", size: size).offset(y: -size * 0.11)
            DecorTile(letter: "c", size: size).rotationEffect(.degrees(3))
        }
        .accessibilityHidden(true)
    }
}

/// A grouped card of rows, as in Settings.
struct SettingsGroup<Content: View>: View {
    var title: String
    var footer: String?
    @ViewBuilder var content: Content
    @Environment(\.palette) private var palette

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title.uppercased())
                .font(TileFont.text(12.5, weight: .semibold))
                .tracking(0.4)
                .foregroundStyle(palette.muted)
                .padding(.horizontal, 16)
                .accessibilityAddTraits(.isHeader)
            VStack(spacing: 0) {
                Group(subviews: content) { rows in
                    ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                        if index > 0 { Rectangle().fill(palette.line).frame(height: 1).padding(.leading, 16) }
                        row
                    }
                }
            }
            .background(palette.card, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            if let footer {
                Text(footer)
                    .font(TileFont.text(13))
                    .foregroundStyle(palette.muted)
                    .padding(.horizontal, 16)
            }
        }
    }
}

/// A settings row: a label and whatever control sits on the right.
struct SettingsRow<Trailing: View>: View {
    var title: String
    @ViewBuilder var trailing: Trailing
    @Environment(\.palette) private var palette

    var body: some View {
        HStack {
            Text(title).foregroundStyle(palette.ink)
            Spacer(minLength: 12)
            trailing
        }
        .font(TileFont.text(16))
        .padding(.horizontal, 16)
        .frame(minHeight: 50)
    }
}

struct ToggleRow: View {
    var title: String
    @Binding var isOn: Bool
    @Environment(\.palette) private var palette

    var body: some View {
        SettingsRow(title: title) {
            Toggle(title, isOn: $isOn).labelsHidden().tint(palette.success)
        }
    }
}

struct SegmentRow<Value: Hashable>: View {
    var title: String
    @Binding var selection: Value
    var options: [(Value, String)]

    var body: some View {
        SettingsRow(title: title) {
            Picker(title, selection: $selection) {
                ForEach(options.indices, id: \.self) { index in
                    Text(options[index].1).tag(options[index].0)
                }
            }
            .pickerStyle(.segmented)
            .fixedSize()
        }
    }
}

/// A row that opens another screen, with its current value.
struct LinkRow<Destination: View>: View {
    var title: String
    var value: String?
    @ViewBuilder var destination: Destination
    @Environment(\.palette) private var palette

    var body: some View {
        NavigationLink {
            destination
        } label: {
            SettingsRow(title: title) {
                HStack(spacing: 6) {
                    if let value { Text(value).foregroundStyle(palette.muted) }
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(palette.muted.opacity(0.7))
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

/// A big choice card with a radio, used for the strip and number options.
struct OptionCard<Preview: View>: View {
    var title: String
    var detail: String
    var selected: Bool
    var action: () -> Void
    @ViewBuilder var preview: Preview
    @Environment(\.palette) private var palette

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(title).font(TileFont.text(16, weight: .semibold))
                    Spacer()
                    Circle()
                        .strokeBorder(selected ? palette.vowel : palette.tileEdge, lineWidth: selected ? 7 : 2)
                        .frame(width: 22, height: 22)
                }
                preview
                Text(detail)
                    .font(TileFont.text(13.5))
                    .foregroundStyle(palette.ink2)
                    .multilineTextAlignment(.leading)
            }
            .foregroundStyle(palette.ink)
            .padding(14)
            .background(palette.card, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(selected ? palette.vowel : palette.line, lineWidth: selected ? 2.5 : 1.5)
            }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(selected ? [.isSelected] : [])
    }
}

/// The keyboard sound in the app, where there's no input view to click through.
enum AppClick {
    static func play() { AudioServicesPlaySystemSound(1104) }
}

extension View {
    /// The page background, edge to edge.
    func pageBackground(_ color: Color) -> some View {
        background(color.ignoresSafeArea())
    }
}
