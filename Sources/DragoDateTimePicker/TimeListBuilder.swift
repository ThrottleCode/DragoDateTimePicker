// TimeListBuilder.swift
// DragoDateTimePicker

import Foundation

enum TimeListBuilder {

    /// All slots for the given format and interval (in minutes).
    static func allSlots(format: DragoTimeFormat, interval: Int = 30) -> [String] {
        let count = (24 * 60) / interval
        return (0 ..< count).map { i in
            let totalMinutes = i * interval
            let hour   = totalMinutes / 60
            let minute = totalMinutes % 60
            return format == .hour24 ? slot24(hour: hour, minute: minute)
                                     : slot12(hour: hour, minute: minute)
        }
    }

    /// Slots starting at `index`. Returns empty array if index is out of range.
    static func build(from index: Int, format: DragoTimeFormat, interval: Int = 30) -> [String] {
        let all = allSlots(format: format, interval: interval)
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
