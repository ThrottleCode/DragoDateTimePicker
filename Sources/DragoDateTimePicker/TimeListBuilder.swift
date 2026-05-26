// TimeListBuilder.swift
// DragoDateTimePicker

import Foundation

enum TimeListBuilder {

    /// All 30-min slots for the given format (48 entries).
    static func allSlots(format: DragoTimeFormat) -> [String] {
        (0 ..< 48).map { i in
            let hour   = (i / 2)
            let minute = (i % 2) * 30
            return format == .hour24 ? slot24(hour: hour, minute: minute)
                                     : slot12(hour: hour, minute: minute)
        }
    }

    /// Slots starting at `index`. Returns empty array if index is out of range.
    static func build(from index: Int, format: DragoTimeFormat) -> [String] {
        let all = allSlots(format: format)
        guard index < all.count else { return [] }
        return Array(all[index...])
    }

    // MARK: - Formatters

    private static func slot24(hour: Int, minute: Int) -> String {
        String(format: "%02d:%02d", hour, minute)
    }

    private static func slot12(hour: Int, minute: Int) -> String {
        let period  = hour < 12 ? "AM" : "PM"
        let display = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour)
        return String(format: "%02d:%02d %@", display, minute, period)
    }
}
