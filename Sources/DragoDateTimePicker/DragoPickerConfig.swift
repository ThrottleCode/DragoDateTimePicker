// DragoPickerConfig.swift
// DragoDateTimePicker

import UIKit

// MARK: - Mode

public enum DragoPickerMode {
    /// Two-column start / end time wheel picker
    case time
    /// Single UIDatePicker in time mode
    case singleTime
    /// Single UIDatePicker in date mode
    case date
    /// Single UIDatePicker in date + time mode
    case dateTime
}

// MARK: - Time Format

public enum DragoTimeFormat {
    /// 12-hour  e.g. 01:30 AM
    case hour12
    /// 24-hour  e.g. 13:30
    case hour24
}

// MARK: - Config

public struct DragoPickerConfig {

    // MARK: Mode
    public var mode:       DragoPickerMode  = .time
    public var timeFormat: DragoTimeFormat  = .hour12

    // MARK: Card
    public var cardBackgroundColor: UIColor = .white
    public var cardCornerRadius:    CGFloat = 20
    public var cardWidth:           CGFloat = 320

    // MARK: Overlay
    public var overlayColor: UIColor = UIColor.black.withAlphaComponent(0.4)

    // MARK: Picker
    public var pickerTextColor:      UIColor = .label
    public var pickerFont:           UIFont  = .systemFont(ofSize: 17)
    public var pickerBackgroundColor: UIColor = .clear

    // MARK: Buttons
    public var okTitle:     String  = "Done"
    public var cancelTitle: String  = "Cancel"
    public var okColor:     UIColor = .systemBlue
    public var cancelColor: UIColor = .systemGray
    public var buttonFont:  UIFont  = .systemFont(ofSize: 16, weight: .semibold)

    // MARK: Title
    public var title:      String?
    public var titleFont:  UIFont  = .systemFont(ofSize: 18, weight: .bold)
    public var titleColor: UIColor = .label

    // MARK: Date picker
    public var minimumDate: Date?
    public var maximumDate: Date?
    public var locale:      Locale = .current

    public init() {}
}
