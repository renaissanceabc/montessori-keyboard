import AudioToolbox
import MontessoriCore
import MontessoriUI
import SwiftUI

/// The dark, full-width button at the bottom of setup screens.
struct PrimaryButton: View {
    var title: String
    var systemImage: String?
    var height: CGFloat = 52
    var action: () -> Void
    @Environment(\.palette) private var palette

    init(_ title: String, systemImage: String? = nil, height: CGFloat = 52, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.height = height
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let systemImage { Image(systemName: systemImage) }
                Text(title)
            }
            .font(TileFont.text(height < 52 ? 16 : 17, weight: .semibold))
            .frame(maxWidth: .infinity, minHeight: height)
            .foregroundStyle(palette.paper)
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
            .background(
                shape.fill(
                    LinearGradient(colors: [palette.tileTop, palette.tileBottom], startPoint: .top, endPoint: .bottom))
            )
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
        let shape = RoundedRectangle(cornerRadius: 12, style: .continuous)
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(TileFont.text(13, relativeTo: .footnote))
                .foregroundStyle(palette.muted)
                .padding(.horizontal, 4)
                .accessibilityAddTraits(.isHeader)
            VStack(spacing: 0) {
                Group(subviews: content) { rows in
                    ForEach(Array(rows.enumerated()), id: \.offset) { index, row in
                        if index > 0 { Rectangle().fill(palette.separator).frame(height: 1) }
                        row
                    }
                }
            }
            .background(palette.card, in: shape)
            .clipShape(shape)
            .overlay { shape.strokeBorder(palette.line, lineWidth: 1) }
            if let footer {
                Text(footer)
                    .font(TileFont.text(12.5, relativeTo: .footnote))
                    .foregroundStyle(palette.muted)
                    .lineSpacing(2)
                    .padding(.horizontal, 4)
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
        .font(TileFont.text(15.5))
        .padding(.horizontal, 14)
        .padding(.vertical, 6)
        .frame(minHeight: 46)
    }
}

struct ToggleRow: View {
    var title: String
    @Binding var isOn: Bool
    @Environment(\.palette) private var palette

    var body: some View {
        SettingsRow(title: title) {
            Toggle(title, isOn: $isOn).labelsHidden().toggleStyle(WoodSwitch())
        }
    }
}

struct SegmentRow<Value: Hashable>: View {
    var title: String
    @Binding var selection: Value
    var options: [(Value, String)]

    var body: some View {
        SettingsRow(title: title) {
            Segments(title: title, selection: $selection, options: options)
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
                    if let value { Text(value).font(TileFont.text(15)).foregroundStyle(palette.muted) }
                    Chevron()
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

/// A number's beads in one row, 5pt each: the setup steps and the gate's keys.
struct BeadRow: View {
    var digit: Int

    var body: some View {
        HStack(spacing: 2) {
            ForEach(0..<digit, id: \.self) { _ in
                Circle().fill(Color(hex: BeadStair.color(for: digit) ?? 0)).frame(width: 5, height: 5)
            }
        }
        .accessibilityHidden(true)
    }
}

/// A green box saying the keyboard is on (Try it, the Setup guide).
struct OnNotice: View {
    var text: String
    @Environment(\.palette) private var palette

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark").font(.callout.weight(.bold)).accessibilityHidden(true)
            Text(text)
        }
        .font(TileFont.text(14))
        .foregroundStyle(palette.successInk)
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(palette.successBackground, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

/// The "›" at the end of a row that opens another screen.
struct Chevron: View {
    @Environment(\.palette) private var palette

    var body: some View {
        Text("›")
            .font(TileFont.text(18))
            .foregroundStyle(palette.chevron)
            .accessibilityHidden(true)
    }
}

/// The canvas's switch: 50×30, green when on, a warm grey when off.
struct WoodSwitch: ToggleStyle {
    @Environment(\.palette) private var palette
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        Button {
            configuration.isOn.toggle()
        } label: {
            Capsule()
                .fill(configuration.isOn ? palette.success : palette.switchOff)
                .frame(width: 50, height: 30)
                .overlay(alignment: configuration.isOn ? .trailing : .leading) {
                    Circle()
                        .fill(.white)
                        .shadow(color: .black.opacity(0.25), radius: 1, y: 1)
                        .frame(width: 26, height: 26)
                        .padding(2)
                }
                .animation(reduceMotion ? nil : .easeOut(duration: 0.16), value: configuration.isOn)
        }
        .buttonStyle(.plain)
        .accessibilityRepresentation {
            Toggle(isOn: configuration.$isOn) { configuration.label }.toggleStyle(.switch)
        }
    }
}

/// The canvas's segmented control: a warm track, the chosen segment raised in white.
struct Segments<Value: Hashable>: View {
    var title: String
    @Binding var selection: Value
    var options: [(Value, String)]
    @Environment(\.palette) private var palette
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        HStack(spacing: 0) {
            ForEach(options.indices, id: \.self) { index in
                let (value, label) = options[index]
                let chosen = value == selection
                Button {
                    selection = value
                } label: {
                    Text(label)
                        .font(TileFont.text(13, weight: chosen ? .semibold : .regular, relativeTo: .footnote))
                        .foregroundStyle(chosen ? palette.ink : palette.ink2)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background {
                            if chosen {
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(palette.segmentSelected)
                                    .shadow(color: .black.opacity(0.12), radius: 1, y: 1)
                            }
                        }
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityAddTraits(chosen ? .isSelected : [])
            }
        }
        .padding(2)
        .background(palette.segmentTrack, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .fixedSize()
        .animation(reduceMotion ? nil : .easeOut(duration: 0.16), value: selection)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(title)
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
