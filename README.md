# DragoDateTimePicker

A clean, modern, fully programmatic iOS date & time picker library written in Swift.  
Supports **Start/End time range**, **single time**, **date**, and **date + time** modes.

---

## Requirements

| | Minimum |
|---|---|
| iOS | 14.0 |
| Swift | 5.9 |
| Xcode | 15.0 |

---

## Installation

### Swift Package Manager

In Xcode → **File → Add Package Dependencies**, paste:

```
https://github.com/ThrottleCode/DragoDateTimePicker
```

Or add it manually in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/ThrottleCode/DragoDateTimePicker", from: "1.0.0")
]
```

---

## Modes

| Mode | Description |
|---|---|
| `.time` | Dual-wheel start & end time picker |
| `.singleTime` | Single wheel — pick one time |
| `.date` | Single wheel — pick a date |
| `.dateTime` | Single wheel — pick date + time |

---

## Usage

### 1. Start & End Time (`.time`)

```swift
import DragoDateTimePicker

var config = DragoPickerConfig()
config.mode       = .time
config.timeFormat = .hour12          // or .hour24
config.title      = "Set Start & End Time"
config.okColor    = .systemBlue

let picker = DragoPickerController()
picker.config = config
picker.modalPresentationStyle = .overFullScreen
picker.modalTransitionStyle   = .crossDissolve

picker.onConfirm = { result in
    print(result.startTime ?? "", result.endTime ?? "")
}
picker.onCancel = { print("Cancelled") }

present(picker, animated: true)
```

---

### 2. Single Time (`.singleTime`)

```swift
var config = DragoPickerConfig()
config.mode  = .singleTime
config.title = "Select Time"

let picker = DragoPickerController()
picker.config = config
picker.modalPresentationStyle = .overFullScreen
picker.modalTransitionStyle   = .crossDissolve

picker.onConfirm = { result in
    print(result.date ?? "")
}
present(picker, animated: true)
```

---

### 3. Date (`.date`)

```swift
var config = DragoPickerConfig()
config.mode        = .date
config.title       = "Select Date"
config.minimumDate = Date()

let picker = DragoPickerController()
picker.config = config
picker.modalPresentationStyle = .overFullScreen
picker.modalTransitionStyle   = .crossDissolve

picker.onConfirm = { result in
    print(result.date ?? "")
}
present(picker, animated: true)
```

---

### 4. Date + Time (`.dateTime`)

```swift
var config = DragoPickerConfig()
config.mode  = .dateTime
config.title = "Select Date & Time"

let picker = DragoPickerController()
picker.config = config
picker.modalPresentationStyle = .overFullScreen
picker.modalTransitionStyle   = .crossDissolve

picker.onConfirm = { result in
    print(result.date ?? "")
}
present(picker, animated: true)
```

---

## Customisation

All visual properties are set via `DragoPickerConfig`:

```swift
var config = DragoPickerConfig()

// Card
config.cardBackgroundColor = .white
config.cardCornerRadius    = 20
config.cardWidth           = 320

// Overlay
config.overlayColor = UIColor.black.withAlphaComponent(0.4)

// Picker wheel
config.pickerTextColor = .label
config.pickerFont      = .systemFont(ofSize: 17)

// Buttons
config.okTitle     = "Done"
config.cancelTitle = "Cancel"
config.okColor     = .systemBlue
config.cancelColor = .systemGray
config.buttonFont  = .systemFont(ofSize: 16, weight: .semibold)

// Title
config.title      = "Pick a Time"
config.titleFont  = .systemFont(ofSize: 18, weight: .bold)
config.titleColor = .label

// Date constraints
config.minimumDate = Date()
config.maximumDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())
config.locale      = .current

// Time format (.time mode only)
config.timeFormat = .hour12   // or .hour24
```

---

## Result

```swift
picker.onConfirm = { result in
    result.startTime  // String? — .time mode
    result.endTime    // String? — .time mode
    result.date       // Date?   — .singleTime / .date / .dateTime
}
```

---

## Publish to GitHub

```bash
cd /Users/mac2/Desktop/DragoDateTimePickerPackage
git init
git add .
git commit -m "Initial release"
git remote add origin https://github.com/ThrottleCode/DragoDateTimePicker.git
git push -u origin main
```

Then tag a release:

```bash
git tag 1.0.0
git push origin 1.0.0
```

---

## License

MIT
