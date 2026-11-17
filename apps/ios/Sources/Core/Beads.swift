import Foundation

/// The bead stair: each number from 1 to 9 has its own color of bead bar in a Montessori classroom.
public enum BeadStair {
    /// Hex colors for 1 through 9. Index 0 is unused so `color[n]` reads naturally. Ten is a golden bar.
    public static let colors: [UInt32] = [
        0x000000,
        0xD2232A, // 1 red
        0x2E9B45, // 2 green
        0xEE86AE, // 3 pink
        0xF2C318, // 4 yellow
        0x6DBFE8, // 5 light blue
        0x8E5BB5, // 6 purple
        0xE9E2D2, // 7 white
        0x8A5A2E, // 8 brown
        0x1E3A8A, // 9 dark blue
    ]

    public static let ten: UInt32 = 0xC9A227

    /// The color for a digit key. Zero has no beads.
    public static func color(for digit: Int) -> UInt32? {
        (1...9).contains(digit) ? colors[digit] : nil
    }
}

/// How the number keys show quantity.
public enum NumberStyle: String, Codable, CaseIterable, Sendable {
    /// Dots in the bead-stair color under each digit.
    case beads
    /// A short bar split into segments, like the number rods.
    case rods
    /// Digits only.
    case plain
}
