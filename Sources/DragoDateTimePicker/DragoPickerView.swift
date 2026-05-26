// DragoPickerView.swift
// DragoDateTimePicker

import UIKit

// MARK: - Delegate

public protocol DragoPickerViewDelegate: AnyObject {
    func dragoPickerDidConfirm(_ result: DragoPickerResult)
    func dragoPickerDidCancel()
}

// MARK: - View

public final class DragoPickerView: UIView {

    public weak var delegate: DragoPickerViewDelegate?
    public private(set) var config: DragoPickerConfig

    private let overlay       = UIButton()
    private let card          = UIView()
    private let titleLabel    = UILabel()
    private let titleDivider  = UIView()
    private let buttonDivider = UIView()
    private let cancelButton  = UIButton(type: .system)
    private let okButton      = UIButton(type: .system)
    private let buttonStack   = UIStackView()

    private var datePicker: UIDatePicker?

    // MARK: Init

    public init(config: DragoPickerConfig) {
        self.config = config
        super.init(frame: .zero)
        buildUI()
    }

    required init?(coder: NSCoder) { fatalError("use init(config:)") }

    // MARK: - Build

    private func buildUI() {
        buildOverlay()
        buildCard()
        buildTitle()
        buildTitleDivider()
        buildDatePicker()
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

    private func buildTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        card.addSubview(titleLabel)
        let topPad: CGFloat = config.title != nil ? 20 : 0
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: topPad),
            titleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16)
        ])
        if config.title == nil {
            titleLabel.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
    }

    private func buildTitleDivider() {
        titleDivider.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(titleDivider)
        let topPad: CGFloat = config.title != nil ? 12 : 0
        NSLayoutConstraint.activate([
            titleDivider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: topPad),
            titleDivider.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            titleDivider.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            titleDivider.heightAnchor.constraint(equalToConstant: config.title != nil ? 0.5 : 0)
        ])
    }

    private func buildDatePicker() {
        let dp = UIDatePicker()
        dp.translatesAutoresizingMaskIntoConstraints = false
        switch config.mode {
        case .singleTime:
            dp.datePickerMode = .time
            // Honour timeFormat the same way .time mode does
            dp.locale = config.timeFormat == .hour12
                ? Locale(identifier: "en_US_POSIX")
                : Locale(identifier: "en_GB")
        case .date:
            dp.datePickerMode = .date
            dp.locale = config.locale
        default:
            dp.datePickerMode = .dateAndTime
            dp.locale = config.locale
        }
        dp.minimumDate = config.minimumDate
        dp.maximumDate = config.maximumDate
        if #available(iOS 13.4, *) { dp.preferredDatePickerStyle = .wheels }
        card.addSubview(dp)
        NSLayoutConstraint.activate([
            dp.topAnchor.constraint(equalTo: titleDivider.bottomAnchor, constant: 8),
            dp.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 8),
            dp.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -8)
        ])
        datePicker = dp
    }

    private func buildButtonDivider() {
        guard let dp = datePicker else { return }
        buttonDivider.translatesAutoresizingMaskIntoConstraints = false
        card.addSubview(buttonDivider)
        NSLayoutConstraint.activate([
            buttonDivider.topAnchor.constraint(equalTo: dp.bottomAnchor, constant: 8),
            buttonDivider.leadingAnchor.constraint(equalTo: card.leadingAnchor),
            buttonDivider.trailingAnchor.constraint(equalTo: card.trailingAnchor),
            buttonDivider.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }

    private func buildButtons() {
        cancelButton.setTitle(config.cancelTitle, for: .normal)
        okButton.setTitle(config.okTitle, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        okButton.addTarget(self, action: #selector(okTapped), for: .touchUpInside)
        cancelButton.layer.cornerRadius = 12
        okButton.layer.cornerRadius     = 12

        buttonStack.axis         = .horizontal
        buttonStack.distribution = .fillEqually
        buttonStack.spacing      = 12
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.addArrangedSubview(cancelButton)
        buttonStack.addArrangedSubview(okButton)
        card.addSubview(buttonStack)

        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: buttonDivider.bottomAnchor, constant: 12),
            buttonStack.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            buttonStack.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
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

        titleLabel.text      = config.title
        titleLabel.font      = config.titleFont
        titleLabel.textColor = config.titleColor
        titleLabel.isHidden  = config.title == nil

        titleDivider.backgroundColor  = .separator
        buttonDivider.backgroundColor = .separator

        cancelButton.titleLabel?.font = config.buttonFont
        cancelButton.setTitleColor(config.cancelColor, for: .normal)
        cancelButton.backgroundColor   = config.cancelColor.withAlphaComponent(0.08)
        cancelButton.layer.borderColor = config.cancelColor.withAlphaComponent(0.3).cgColor
        cancelButton.layer.borderWidth = 1

        okButton.titleLabel?.font = config.buttonFont
        okButton.setTitleColor(.white, for: .normal)
        okButton.backgroundColor  = config.okColor

        datePicker?.backgroundColor = config.pickerBackgroundColor
    }

    // MARK: - Actions

    @objc private func okTapped() {
        delegate?.dragoPickerDidConfirm(DragoPickerResult(date: datePicker?.date))
    }

    @objc private func cancelTapped() {
        delegate?.dragoPickerDidCancel()
    }
}
