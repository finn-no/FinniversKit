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
        formatter.timeZone = .init(abbreviation: "Europe/Oslo")
        formatter.dateFormat = "MMMM yyyy"
        return formatter
    }()

    private lazy var currentDateLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private lazy var textField: TextField = {
        let picker = MonthAndYearPickerView(frame: .zero, inputViewStyle: .default)
        picker.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        picker.setSelectedDate(currentDate, animated: true)
        picker.delegate = self

        let textField = TextField(inputType: .normal)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.textField.inputView = picker
        return textField
    }()

    private lazy var pickerView: MonthAndYearPickerView = {
        let view = MonthAndYearPickerView(withAutoLayout: true)
        view.delegate = self
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

}

extension MonthAndYearPickerDemoView: MonthAndYearPickerViewDelegate {
    func monthAndYearPickerView(_ view: MonthAndYearPickerView, didSelectDate date: Date) {
        currentDate = date

        // Update when edited from inputView
        if view !== pickerView {
            pickerView.setSelectedDate(date, animated: true)
        }

        // Update when edited from pickerView
        if view === pickerView, let inputView = textField.textField.inputView as? MonthAndYearPickerView {
            inputView.setSelectedDate(date, animated: true)
        }
    }
}
