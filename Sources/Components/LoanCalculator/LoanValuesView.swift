//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol LoanValuesViewModel {
    var price: TitleValueSliderViewModel { get }
    var equity: TitleValueSliderViewModel { get }
    var paymentYears: TitleValueSliderViewModel { get }
}

protocol LoanValuesViewDataSource: AnyObject {
    func loanValuesView(_ view: LoanValuesView, formattedCurrencyValue: Float) -> String?
    func loanValuesView(_ view: LoanValuesView, formattedYearsValue: Int) -> String?
}

protocol LoanValuesViewDelegate: AnyObject {
    func loanValuesViewDidChangeValue(_ view: LoanValuesView)
    func loanValuesView(_ view: LoanValuesView, didChangePrice: Float)
    func loanValuesView(_ view: LoanValuesView, didChangeEquity: Float)
    func loanValuesView(_ view: LoanValuesView, didChangePaymentYears: Int)
}

class LoanValuesView: UIView {
    weak var dataSource: LoanValuesViewDataSource?
    weak var delegate: LoanValuesViewDelegate?

    // MARK: - Private subviews
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = .mediumLargeSpacing
        return stackView
    }()

    private lazy var priceView: TitleValueSlider = {
        let view = TitleValueSlider(numberOfSteps: 280, withAutoLayout: true)
        view.dataSource = self
        view.delegate = self
        return view
    }()

    private lazy var equityView: TitleValueSlider = {
        let view = TitleValueSlider(numberOfSteps: 280, withAutoLayout: true)
        view.dataSource = self
        view.delegate = self
        return view
    }()

    private lazy var paymentYearsView: TitleValueSlider = {
        let view = TitleValueSlider(numberOfSteps: 25, withAutoLayout: true)
        view.dataSource = self
        view.delegate = self
        return view
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Internal methods
    func configure(with model: LoanValuesViewModel) {
        priceView.configure(with: model.price)
        equityView.configure(with: model.equity)
        paymentYearsView.configure(with: model.paymentYears)
    }

    // MARK: - Private methods
    private func setup() {
        stackView.addArrangedSubview(priceView)
        stackView.addArrangedSubview(equityView)
        stackView.addArrangedSubview(paymentYearsView)
        addSubview(stackView)
        stackView.fillInSuperview()
    }
}

// MARK: - TitleValueSliderDataSource
extension LoanValuesView: TitleValueSliderDataSource {
    func titleValueSlider(_ view: TitleValueSlider, titleForValue value: Float) -> String? {
        switch view {
        case priceView, equityView:
            return dataSource?.loanValuesView(self, formattedCurrencyValue: value)
        case paymentYearsView:
            return dataSource?.loanValuesView(self, formattedYearsValue: Int(value))
        default:
            return nil
        }
    }
}

// MARK: - TitleValueSliderDelegate
extension LoanValuesView: TitleValueSliderDelegate {
    func titleValueSlider(_ view: TitleValueSlider, didChangeValue value: Float) {
        delegate?.loanValuesViewDidChangeValue(self)
    }

    func titleValueSlider(_ view: TitleValueSlider, didEndSlideInteractionWithValue value: Float) {
        switch view {
        case priceView:
            delegate?.loanValuesView(self, didChangePrice: value)
        case equityView:
            delegate?.loanValuesView(self, didChangeEquity: value)
        case paymentYearsView:
            delegate?.loanValuesView(self, didChangePaymentYears: Int(value))
        default:
            break
        }
    }
}
