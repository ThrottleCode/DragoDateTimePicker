// DragoPickerController.swift
// DragoDateTimePicker

import UIKit

// MARK: - Controller

/// The single entry point for presenting any picker mode.
/// Set `config`, then present with `.overFullScreen` + `.crossDissolve`.
public final class DragoPickerController: UIViewController {

    /// Configuration — set before presenting.
    public var config: DragoPickerConfig = DragoPickerConfig()

    /// Called when the user confirms a selection.
    public var onConfirm: ((DragoPickerResult) -> Void)?

    /// Called when the user cancels.
    public var onCancel: (() -> Void)?

    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        config.mode == .time ? embedRangeSheet() : embedPickerView()
    }

    // MARK: - Embed

    private func embedRangeSheet() {
        let sheet = DragoTimeRangeSheet(config: config)
        sheet.delegate = self
        embed(sheet)
    }

    private func embedPickerView() {
        let pv = DragoPickerView(config: config)
        pv.delegate = self
        embed(pv)
    }

    private func embed(_ child: UIView) {
        child.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(child)
        NSLayoutConstraint.activate([
            child.topAnchor.constraint(equalTo: view.topAnchor),
            child.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            child.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            child.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - DragoTimeRangeSheetDelegate

extension DragoPickerController: DragoTimeRangeSheetDelegate {

    public func timeRangeSheet(_ sheet: DragoTimeRangeSheet, didSelect start: String, end: String) {
        onConfirm?(DragoPickerResult(startTime: start, endTime: end))
        dismiss(animated: true)
    }

    public func timeRangeSheetDidCancel(_ sheet: DragoTimeRangeSheet) {
        onCancel?()
        dismiss(animated: true)
    }
}

// MARK: - DragoPickerViewDelegate

extension DragoPickerController: DragoPickerViewDelegate {

    public func dragoPickerDidConfirm(_ result: DragoPickerResult) {
        onConfirm?(result)
        dismiss(animated: true)
    }

    public func dragoPickerDidCancel() {
        onCancel?()
        dismiss(animated: true)
    }
}
