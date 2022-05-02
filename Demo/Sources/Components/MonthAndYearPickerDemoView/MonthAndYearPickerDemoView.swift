import FinniversKit
import Foundation

class MonthAndYearPickerDemoView: UIView {

    private var currentDate: Date = Date(timeIntervalSince1970: 1648771200) { // 2022-04-01
        didSet {
            updateDateLabel()
        }
    }

    private lazy var calendar = Calendar(identifier: .iso8601)

    private lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .init(identifier: "nb_NO")
        formatter.timeZone = .autoupdatingCurrent
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()

    private lazy var currentDateLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private lazy var toolbar: UIToolbar = {
        let toolbar = UIToolbar()

        if #available(iOS 14.0, *) {
            let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            let item = UIBarButtonItem(title: "Ferdig", image: nil, primaryAction: UIAction(handler: { [weak self] _ in
                self?.textField.endEditing(true)
            }))

            toolbar.sizeToFit()
            toolbar.items = [space, item]
        }

        return toolbar
    }()

    private lazy var textField: TextField = {
        let picker = MonthAndYearPickerView()
        picker.setSelectedDate(currentDate, animated: true)
        picker.addTarget(self, action: #selector(handleTextFieldDateInput), for: .valueChanged)

        let textField = TextField(inputType: .normal)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textField.inputView = picker
        textField.textField.inputAccessoryView = toolbar
        return textField
    }()

    private lazy var pickerView: MonthAndYearPickerView = {
        let view = MonthAndYearPickerView(withAutoLayout: true)
        view.addTarget(self, action: #selector(handlePickerDateInput), for: .valueChanged)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(currentDateLabel)
        addSubview(pickerView)
        addSubview(textField)

        NSLayoutConstraint.activate([
            currentDateLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingM),
            currentDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            currentDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            textField.topAnchor.constraint(equalTo: currentDateLabel.bottomAnchor, constant: .spacingM),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            pickerView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: .spacingM),
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            pickerView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: .spacingM),
        ])

        setInitialDate()
    }

    private func setInitialDate() {
        pickerView.setSelectedDate(currentDate, animated: false)
        updateDateLabel()
    }

    private func updateDateLabel() {
        let formattedDate = formatter.string(from: currentDate)
        currentDateLabel.text = formattedDate + "\nUTC: " + currentDate.debugDescription
        textField.text = formattedDate
    }

    @objc private func handleTextFieldDateInput(_ sender: MonthAndYearPickerView) {
        currentDate = sender.selectedDate

        pickerView.setSelectedDate(currentDate, animated: true)
    }

    @objc private func handlePickerDateInput(_ sender: MonthAndYearPickerView) {
        currentDate = sender.selectedDate

        if let inputView = textField.textField.inputView as? MonthAndYearPickerView {
            inputView.setSelectedDate(currentDate, animated: true)
        }
    }

}
