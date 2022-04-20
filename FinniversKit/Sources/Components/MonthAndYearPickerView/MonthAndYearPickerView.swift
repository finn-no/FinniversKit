import UIKit

public protocol MonthAndYearPickerViewDelegate: AnyObject {
    func monthAndYearPickerView(_ view: MonthAndYearPickerView, didSelectDate date: Date)
}

public class MonthAndYearPickerView: UIInputView {
    public weak var delegate: MonthAndYearPickerViewDelegate?

    public var minimumYear: Int = 1900

    private var years: [Int] {
        let currentYear = calendar.component(.year, from: Date())
        return [Int](minimumYear...currentYear)
    }

    private var months: [String] {
        calendar.monthSymbols
    }

    private lazy var calendar: Calendar = {
        var calendar = Calendar(identifier: .iso8601)
        calendar.locale = .autoupdatingCurrent
        return calendar
    }()

    private lazy var pickerView: UIPickerView = {
        let view = UIPickerView(withAutoLayout: true)
        view.dataSource = self
        view.delegate = self
        return view
    }()

    public override init(frame: CGRect, inputViewStyle: UIInputView.Style) {
        super.init(frame: frame, inputViewStyle: inputViewStyle)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        allowsSelfSizing = true

        addSubview(pickerView)
        pickerView.fillInSuperview()
    }

    public func setSelectedDate(_ date: Date, animated: Bool) {
        let components = calendar.dateComponents([.month, .year], from: date)

        guard
            let monthComponent = components.month,
            let yearComponent = components.year,
            let yearIndex = years.firstIndex(of: yearComponent)
        else {
            return
        }

        let monthIndex = monthComponent - 1
        pickerView.selectRow(monthIndex, inComponent: .month, animated: animated)
        pickerView.selectRow(yearIndex, inComponent: .year, animated: animated)
    }
}

// MARK: - UIPickerViewDataSource
extension MonthAndYearPickerView: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        UIPickerView.Component.allCases.count
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let component = UIPickerView.Component(rawValue: component) else {
            return 0
        }

        switch component {
        case .month:
            return months.count
        case .year:
            return years.count
        }
    }
}

// MARK: - UIPickerViewDelegate
extension MonthAndYearPickerView: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let component = UIPickerView.Component(rawValue: component) else {
            return nil
        }

        switch component {
        case .month:
            return months[row]
        case .year:
            return String(years[row])
        }
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let month = pickerView.selectedRow(inComponent: .month) + 1
        let year = years[pickerView.selectedRow(inComponent: .year)]

        let components = DateComponents(calendar: calendar, year: year, month: month)

        if let date = calendar.date(from: components) {
            delegate?.monthAndYearPickerView(self, didSelectDate: date)
        }
    }
}

// MARK: - UIPickerView extensions
private extension UIPickerView {
    enum Component: Int, CaseIterable {
        case month
        case year
    }

    func selectedRow(inComponent component: Component) -> Int {
        selectedRow(inComponent: component.rawValue)
    }

    func selectRow(_ row: Int, inComponent component: Component, animated: Bool) {
        selectRow(row, inComponent: component.rawValue, animated: animated)
    }
}
