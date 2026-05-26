import UIKit
import DragoDateTimePicker

final class ExampleViewController: UIViewController {

    // MARK: - UI

    private let stackView   = UIStackView()
    private let resultLabel = UILabel()

    private let buttons: [(title: String, color: UIColor)] = [
        ("⏱  Start & End Time  (.time)",       .systemBlue),
        ("🕐  Single Time  (.singleTime)",      .systemIndigo),
        ("📅  Date  (.date)",                   .systemGreen),
        ("📅⏱  Date & Time  (.dateTime)",       .systemOrange)
    ]

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DragoDateTimePicker"
        view.backgroundColor = UIColor.systemGroupedBackground
        buildUI()
    }

    // MARK: - Build UI

    private func buildUI() {
        // Stack
        stackView.axis      = .vertical
        stackView.spacing   = 16
        stackView.alignment = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])

        // Buttons
        for (index, item) in buttons.enumerated() {
            let btn = UIButton(type: .system)
            btn.setTitle(item.title, for: .normal)
            btn.titleLabel?.font    = .systemFont(ofSize: 16, weight: .semibold)
            btn.backgroundColor     = item.color
            btn.setTitleColor(.white, for: .normal)
            btn.layer.cornerRadius  = 14
            btn.heightAnchor.constraint(equalToConstant: 52).isActive = true
            btn.tag = index
            btn.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            stackView.addArrangedSubview(btn)
        }

        // Result label
        resultLabel.text          = "Result will appear here"
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 0
        resultLabel.font          = .systemFont(ofSize: 14)
        resultLabel.textColor     = .secondaryLabel
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resultLabel)

        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 32),
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32)
        ])
    }

    // MARK: - Actions

    @objc private func buttonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0: presentTimePicker()
        case 1: presentSingleTimePicker()
        case 2: presentDatePicker()
        case 3: presentDateTimePicker()
        default: break
        }
    }

    // MARK: - Pickers

    private func presentTimePicker() {
        var config         = DragoPickerConfig()
        config.mode        = .time
        config.timeFormat  = .hour12
        config.title       = "Set Start & End Time"
        config.okColor     = .systemBlue
        config.timeInterval = 30

        present(makePicker(config: config), animated: true)
    }

    private func presentSingleTimePicker() {
        var config        = DragoPickerConfig()
        config.mode       = .singleTime
        config.timeFormat = .hour12
        config.title      = "Select Time"
        config.okColor    = .systemIndigo

        present(makePicker(config: config), animated: true)
    }

    private func presentDatePicker() {
        var config         = DragoPickerConfig()
        config.mode        = .date
        config.title       = "Select Date"
        config.minimumDate = Date()
        config.okColor     = .systemGreen

        present(makePicker(config: config), animated: true)
    }

    private func presentDateTimePicker() {
        var config     = DragoPickerConfig()
        config.mode    = .dateTime
        config.title   = "Select Date & Time"
        config.okColor = .systemOrange

        present(makePicker(config: config), animated: true)
    }

    // MARK: - Helper

    private func makePicker(config: DragoPickerConfig) -> DragoPickerController {
        let picker = DragoPickerController()
        picker.config = config
        picker.modalPresentationStyle = .overFullScreen
        picker.modalTransitionStyle   = .crossDissolve

        picker.onConfirm = { [weak self] result in
            if let start = result.startTime, let end = result.endTime {
                self?.showResult("Start: \(start)\nEnd:   \(end)")
            } else if let date = result.date {
                let fmt        = DateFormatter()
                fmt.dateStyle  = .medium
                fmt.timeStyle  = config.mode == .date ? .none : .short
                self?.showResult(fmt.string(from: date))
            }
        }

        picker.onCancel = { [weak self] in
            self?.showResult("Cancelled")
        }

        return picker
    }

    private func showResult(_ text: String) {
        resultLabel.text      = text
        resultLabel.textColor = .label
    }
}
