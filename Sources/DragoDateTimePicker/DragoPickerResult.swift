// DragoPickerResult.swift
// DragoDateTimePicker

import Foundation

/// Returned by the picker on confirmation.
public struct DragoPickerResult {
    /// Selected start time string  (`.time` mode only)
    public var startTime: String?
    /// Selected end time string    (`.time` mode only)
    public var endTime:   String?
    /// Selected date               (`.date` / `.singleTime` / `.dateTime` modes)
    public var date:      Date?

    public init(startTime: String? = nil, endTime: String? = nil, date: Date? = nil) {
        self.startTime = startTime
        self.endTime   = endTime
        self.date      = date
    }
}
