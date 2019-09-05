//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol LoanCalculatorViewModel: LoanHeaderViewModel, LoanValuesViewModel, LoanApplyViewModel {}

public protocol LoanCalculatorDataSource: AnyObject {
    func loanCalculatorView(_ view: LoanCalculatorView, formattedCurrencyValue: Float) -> String?
    func loanCalculatorView(_ view: LoanCalculatorView, formattedYearsValue: Int) -> String?
}

public protocol LoanCalculatorDelegate: AnyObject {
    func loanValuesView(_ view: LoanCalculatorView, didChangePrice price: Float)
    func loanValuesView(_ view: LoanCalculatorView, didChangeOwnedAmount amount: Float)
    func loanValuesView(_ view: LoanCalculatorView, didChangePaymentYears years: Int)
    func loanValuesViewDidSelectApply(_ view: LoanCalculatorView)
}

public class LoanCalculatorView: UIView {
    // MARK: - Public properties
    public weak var dataSource: LoanCalculatorDataSource?
    public weak var delegate: LoanCalculatorDelegate?

    // MARK: - Private subviews
    private lazy var headerView = LoanHeaderView(withAutoLayout: true)

    private lazy var loanValuesView: LoanValuesView = {
        let view = LoanValuesView(withAutoLayout: true)
        view.dataSource = self
        view.delegate = self
        return view
    }()

    private lazy var applyView: LoanApplyView = {
        let view = LoanApplyView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    // MARK: - Initializers
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Public methods
    public func configure(with model: LoanCalculatorViewModel) {
        headerView.configure(with: model)
        loanValuesView.configure(with: model)
        applyView.configure(with: model)
    }

    // MARK: - Private methods
    private func setup() {
        backgroundColor = .marble
        directionalLayoutMargins = .init(all: .mediumLargeSpacing * 1.5)

        addSubview(headerView)
        addSubview(loanValuesView)
        addSubview(applyView)

        let margins = layoutMarginsGuide

        if UIDevice.isIPad() {
            NSLayoutConstraint.activate([
                loanValuesView.topAnchor.constraint(equalTo: margins.topAnchor),
                loanValuesView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
                loanValuesView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
                loanValuesView.widthAnchor.constraint(equalTo: headerView.widthAnchor),

                headerView.topAnchor.constraint(equalTo: margins.topAnchor),
                headerView.leadingAnchor.constraint(equalTo: loanValuesView.trailingAnchor, constant: .veryLargeSpacing),
                headerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
                headerView.bottomAnchor.constraint(equalTo: applyView.topAnchor, constant: -.largeSpacing),

                applyView.leadingAnchor.constraint(equalTo: loanValuesView.trailingAnchor, constant: .veryLargeSpacing),
                applyView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
                applyView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                headerView.topAnchor.constraint(equalTo: margins.topAnchor),
                headerView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
                headerView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
                headerView.bottomAnchor.constraint(equalTo: loanValuesView.topAnchor, constant: -.largeSpacing),

                loanValuesView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
                loanValuesView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
                loanValuesView.bottomAnchor.constraint(equalTo: applyView.topAnchor, constant: -.largeSpacing),

                applyView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
                applyView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
                applyView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            ])
        }
    }
}

// MARK: - LoanValuesViewDataSource

extension LoanCalculatorView: LoanValuesViewDataSource {
    func loanValuesView(_ view: LoanValuesView, formattedCurrencyValue value: Float) -> String? {
        return dataSource?.loanCalculatorView(self, formattedCurrencyValue: value)
    }

    func loanValuesView(_ view: LoanValuesView, formattedYearsValue value: Int) -> String? {
        return dataSource?.loanCalculatorView(self, formattedYearsValue: value)
    }
}

// MARK: - LoanValuesViewDelegate

extension LoanCalculatorView: LoanValuesViewDelegate {
    func loanValuesView(_ view: LoanValuesView, didChangePrice price: Float) {
        delegate?.loanValuesView(self, didChangePrice: price)
    }

    func loanValuesView(_ view: LoanValuesView, didChangeOwnedAmount amount: Float) {
        delegate?.loanValuesView(self, didChangeOwnedAmount: amount)
    }

    func loanValuesView(_ view: LoanValuesView, didChangePaymentYears years: Int) {
        delegate?.loanValuesView(self, didChangePaymentYears: years)
    }
}

// MARK: - LoanApplyViewDelegate

extension LoanCalculatorView: LoanApplyViewDelegate {
    func loanApplyViewDidSelectApply(_ view: LoanApplyView) {
        delegate?.loanValuesViewDidSelectApply(self)
    }
}
