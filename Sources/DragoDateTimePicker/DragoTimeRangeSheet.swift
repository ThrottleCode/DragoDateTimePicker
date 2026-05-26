// DragoTimeRangeSheet.swift
// DragoDateTimePicker

import UIKit

// MARK: - Delegate

public protocol DragoTimeRangeSheetDelegate: AnyObject {
    func timeRangeSheet(_ sheet: DragoTimeRangeSheet, didSelect start: String, end: String)
    func timeRangeSheetDidCancel(_ sheet: DragoTimeRangeSheet)
}

// MARK: - View

public final class DragoTimeRangeSheet: UIView {

    public weak var delegate: DragoTimeRangeSheetDelegate?
    public var config: DragoPickerConfig

    // chrome
    private let overlay      = UIButton()
    private let card         = UIView()
    private let handle       = UIView()
    private let titleLabel   = UILabel()
    private let titleDivider = UIView()

    // picker area
    private let startLabel  = UILabel()
    private let endLabel    = UILabel()
    private let startPicker = UIPickerView()
    private let endPicker   = UIPickerView()
    private let pickerStack = UIStackView()
    private let topLine1    = UIView()
    private let topLine2    = UIView()
    private let bottomLine1 = UIView()
    private let bottomLine2 = UIView()

    // buttons
    private let buttonDivider = UIView()
    private let cancelButton  = UIButton(type: .system)
    private let doneButton    = UIButton(type: .system)
    private let buttonStack   = UIStackView()

    // data
    private var startTimes: [String] = []
    private var endTimes:   [String] = []

    private let rowHeight: CGFloat = 44

    // MARK: Init

    public init(config: DragoPickerConfig) {
        self.config = config
        super.init(frame: .zero)
        buildUI()
    }

    required init?(coder: NSCoder) { fatalError("use init(config:)") }

    // MARK: - Build

    private func buildUI() {
        startTimes = TimeListBuilder.build(from: 0, format: config.timeFormat)
        endTimes   = TimeListBuilder.build(from: 1, format: config.timeFormat)

        buildOverlay()
        buildCard()
        buildHandle()
        buildTitle()
        buildTitleDivider()
        buildPickerArea()
        buildButtonDivider()
        buildButtons()
        applyStyle()
    }

    private func buildOverlay() {
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        addSubview(overlay)
        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: topAnchor),
            overlay.bottomAnchor.constraint(equalTo: bottomAnchor),
            overlay.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

    private func buildCard() {
        card.translatesAutoresizingMaskIntoConstraints = false
        addSubview(card)
        NSLayoutConstraint.activate([
            card.centerXAnchor.constraint(equalTo: centerXAnchor),
            card.centerYAnchor.constraint(equalTo: centerYAnchor),
            card.widthAnchor.constraint(equalToConstant: config.cardWidth)
        ])
    }

    private func buildHandle() {
        handle.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(handle)
        NSLayoutConstraint.activate([
            handle.topAnchor.constraint(equalTo: card.topAnchor, constant: 10),
            handle.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            handle.widthAnchor.constraint(equalToConstant: 36),
            handle.heightAnchor.constraint(equalToConstant: 4)
        ])
    }

    private func buildTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        card.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: handle.bottomAnchor, constant: 14),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20)
        ])
    }

    private func buildTitleDivider() {
        titleDivider.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleDivider)
        NSLayoutConstraint.activate([
            titleDivider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 14),
            titleDivider.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            titleDivider.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            titleDivider.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    private func buildPickerArea() {
        // column labels
        for lbl in [startLabel, endLabel] {
            lbl.translatesAutoresizingMaskIntoConstraints = false
            card.addSubview(lbl)
        }
        NSLayoutConstraint.activate([
            startLabel.topAnchor.constraint(equalTo: titleDivider.bottomAnchor, constant: 14),
            startLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            startLabel.widthAnchor.constraint(equalTo: card.widthAnchor, multiplier: 0.5),

            endLabel.topAnchor.constraint(equalTo: titleDivider.bottomAnchor, constant: 14),
            endLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            endLabel.widthAnchor.constraint(equalTo: card.widthAnchor, multiplier: 0.5)
        ])

        // pickers
        startPicker.tag = 0; endPicker.tag = 1
        for pv in [startPicker, endPicker] {
            pv.delegate   = self
            pv.dataSource = self
            pv.translatesAutoresizingMaskIntoConstraints = false
        }

        pickerStack.axis         = .horizontal
        pickerStack.distribution = .fillEqually
        pickerStack.translatesAutoresizingMaskIntoConstraints = false
        pickerStack.addArrangedSubview(startPicker)
        pickerStack.addArrangedSubview(endPicker)
        card.addSubview(pickerStack)

        NSLayoutConstraint.activate([
            pickerStack.topAnchor.constraint(equalTo: startLabel.bottomAnchor, constant: 4),
            pickerStack.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            pickerStack.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            pickerStack.heightAnchor.constraint(equalToConstant: rowHeight * 5)
        ])

        // selection indicator lines
        let midY = rowHeight * 2
        for line in [topLine1, topLine2, bottomLine1, bottomLine2] {
            line.translatesAutoresizingMaskIntoConstraints = false
            card.addSubview(line)
        }
        NSLayoutConstraint.activate([
            topLine1.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            topLine1.trailingAnchor.constraint(equalTo: card.centerXAnchor, constant: -16),
            topLine1.topAnchor.constraint(equalTo: pickerStack.topAnchor, constant: midY),
            topLine1.heightAnchor.constraint(equalToConstant: 0.5),

            topLine2.leadingAnchor.constraint(equalTo: card.centerXAnchor, constant: 16),
            topLine2.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            topLine2.topAnchor.constraint(equalTo: pickerStack.topAnchor, constant: midY),
            topLine2.heightAnchor.constraint(equalToConstant: 0.5),

            bottomLine1.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            bottomLine1.trailingAnchor.constraint(equalTo: card.centerXAnchor, constant: -16),
            bottomLine1.topAnchor.constraint(equalTo: pickerStack.topAnchor, constant: midY + rowHeight),
            bottomLine1.heightAnchor.constraint(equalToConstant: 0.5),

            bottomLine2.leadingAnchor.constraint(equalTo: card.centerXAnchor, constant: 16),
            bottomLine2.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            bottomLine2.topAnchor.constraint(equalTo: pickerStack.topAnchor, constant: midY + rowHeight),
            bottomLine2.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    private func buildButtonDivider() {
        buttonDivider.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(buttonDivider)
        NSLayoutConstraint.activate([
            buttonDivider.topAnchor.constraint(equalTo: pickerStack.bottomAnchor, constant: 8),
            buttonDivider.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            buttonDivider.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            buttonDivider.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    private func buildButtons() {
        cancelButton.setTitle(config.cancelTitle, for: .normal)
        doneButton.setTitle(config.okTitle, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        doneButton.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        cancelButton.layer.cornerRadius = 12
        doneButton.layer.cornerRadius   = 12

        buttonStack.axis         = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing      = 12
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.addArrangedSubview(cancelButton)
        buttonStack.addArrangedSubview(doneButton)
        card.addSubview(buttonStack)

        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: buttonDivider.bottomAnchor, constant: 16),
            buttonStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -20),
            buttonStack.heightAnchor.constraint(equalToConstant: 50),
            buttonStack.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -16)
        ])
    }

    // MARK: - Style

    private func applyStyle() {
        overlay.backgroundColor = config.overlayColor

        card.backgroundColor    = config.cardBackgroundColor
        card.layer.cornerRadius = config.cardCornerRadius
        card.clipsToBounds      = true

        handle.backgroundColor    = .systemGray4
        handle.layer.cornerRadius = 2

        titleLabel.text      = config.title ?? "Set Start & End Time"
        titleLabel.font      = config.titleFont
        titleLabel.textColor = config.titleColor

        titleDivider.backgroundColor  = .separator
        buttonDivider.backgroundColor = .separator

        startLabel.text = "START"
        endLabel.text   = "END"
        for lbl in [startLabel, endLabel] {
            lbl.textAlignment = .center
            lbl.font          = .systemFont(ofSize: 11, weight: .semibold)
            lbl.textColor     = .secondaryLabel
        }

        for line in [topLine1, topLine2, bottomLine1, bottomLine2] {
            line.backgroundColor = .separator
        }

        cancelButton.titleLabel?.font = config.buttonFont
        cancelButton.setTitleColor(config.cancelColor, for: .normal)
        cancelButton.backgroundColor   = config.cancelColor.withAlphaComponent(0.08)
        cancelButton.layer.borderColor = config.cancelColor.withAlphaComponent(0.3).cgColor
        cancelButton.layer.borderWidth = 1

        doneButton.titleLabel?.font = config.buttonFont
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.backgroundColor  = config.okColor
    }

    // MARK: - Actions

    @objc private func doneTapped() {
        let s = startPicker.selectedRow(inComponent: 0)
        let e = endPicker.selectedRow(inComponent: 0)
        let start = startTimes.indices.contains(s) ? startTimes[s] : startTimes.first ?? ""
        let end   = endTimes.indices.contains(e)   ? endTimes[e]   : endTimes.first  ?? ""
        delegate?.timeRangeSheet(self, didSelect: start, end: end)
    }

    @objc private func cancelTapped() {
        delegate?.timeRangeSheetDidCancel(self)
    }
}

// MARK: - UIPickerViewDataSource & Delegate

extension DragoTimeRangeSheet: UIPickerViewDataSource, UIPickerViewDelegate {

    public func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        pickerView.tag == 0 ? startTimes.count : endTimes.count
    }

    public func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        rowHeight
    }

    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let times      = pickerView.tag == 0 ? startTimes : endTimes
        let label      = (view as? UILabel) ?? UILabel()
        let isSelected = row == pickerView.selectedRow(inComponent: 0)

        label.text          = times[row]
        label.textAlignment = .center
        label.font          = isSelected
            ? UIFont.systemFont(ofSize: 20, weight: .semibold)
            : UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textColor     = isSelected
            ? config.pickerTextColor
            : config.pickerTextColor.withAlphaComponent(0.3)
        return label
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadComponent(0)
        guard pickerView.tag == 0 else { return }
        let next = TimeListBuilder.build(from: row + 1, format: config.timeFormat)
        endTimes = next.isEmpty ? [startTimes[row]] : next
        endPicker.reloadComponent(0)
        endPicker.selectRow(0, inComponent: 0, animated: true)
    }
}
