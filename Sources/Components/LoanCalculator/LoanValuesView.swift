//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

protocol LoanValuesViewDelegate: AnyObject {
    func loadValuesView(_ view: LoanValuesView, didChangePrice: Double)
    func loadValuesView(_ view: LoanValuesView, didChangeOwnedAmount: Double)
    func loadValuesView(_ view: LoanValuesView, didChangePaymentYears: Int)
}

class LoanValuesView: UIView {
    weak var delegate: LoanValuesViewDelegate?

    // MARK: - Private subviews
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = .mediumLargeSpacing
        return stackView
    }()

    private lazy var priceView: TitleValueSlider = {
        let view = TitleValueSlider(numberFormatter: currencyFormatter, withAutoLayout: true)
        view.delegate = self
        return view
    }()

    private lazy var ownedAmountView: TitleValueSlider = {
        let view = TitleValueSlider(numberFormatter: currencyFormatter, withAutoLayout: true)
        view.delegate = self
        return view
    }()

    private lazy var paymentYearsView: TitleValueSlider = {
        let view = TitleValueSlider(numberFormatter: yearAmountFormatter, withAutoLayout: true)
        view.delegate = self
        return view
    }()

    private lazy var currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.groupingSeparator = " "
        return formatter
    }()

    private lazy var yearAmountFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        return formatter
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Private functions
    private func setup() {
        priceView.configure(with: DefaultTitleValueSliderViewModel.price)
        ownedAmountView.configure(with: DefaultTitleValueSliderViewModel.ownedAmount)
        paymentYearsView.configure(with: DefaultTitleValueSliderViewModel.paymentYears)

        stackView.addArrangedSubview(priceView)
        stackView.addArrangedSubview(ownedAmountView)
        stackView.addArrangedSubview(paymentYearsView)
        addSubview(stackView)
        stackView.fillInSuperview()
    }
}

extension LoanValuesView: TitleValueSliderDelegate {
    func titleValueSlider(_ view: TitleValueSlider, didChangeValue value: Float) {
        switch view {
        case priceView:
            delegate?.loadValuesView(self, didChangePrice: Double(value))
        case ownedAmountView:
            delegate?.loadValuesView(self, didChangeOwnedAmount: Double(value))
        case paymentYearsView:
            delegate?.loadValuesView(self, didChangePaymentYears: Int(value))
        default:
            break
        }
    }
}
