//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public class LoanCalculatorView: UIView {
    // MARK: - Private subviews
    private lazy var headerView: LoanHeaderView = {
        let view = LoanHeaderView(withAutoLayout: true)
        return view
    }()

    private lazy var loanValuesView: LoanValuesView = {
        let view = LoanValuesView(withAutoLayout: true)
        return view
    }()

    private lazy var applyView: LoanApplyView = {
        let view = LoanApplyView(withAutoLayout: true)
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

    // MARK: - Private functions
    private func setup() {
        backgroundColor = .marble
        directionalLayoutMargins = .init(all: .mediumLargeSpacing * 1.5)

        headerView.configure(with: DefaultLoanHeaderViewModel.test)
        applyView.configure(with: DefaultLoanApplyViewModel.test)

        addSubview(headerView)
        addSubview(loanValuesView)
        addSubview(applyView)

        let margins = layoutMarginsGuide
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

struct DefaultLoanHeaderViewModel: LoanHeaderViewModel {
    let title: String
    let rentText: String
    let pricePerMonth: String
    let loanAmountText: String
    let logo: UIImage?
}

extension DefaultLoanHeaderViewModel {
    static let test = DefaultLoanHeaderViewModel(
        title: "Estimert pr måned",
        rentText: "2,65 % eff. / 2,55 % nom. rente",
        pricePerMonth: "16 656 kr",
        loanAmountText: "Lånesum: 3 675 000 kr",
        logo: UIImage(named: .home)
    )
}

struct DefaultTitleValueSliderViewModel: TitleValueSliderViewModel {
    let title: String
    let minimumValue: Int
    let maximumValue: Int
    let initialValue: Int
}

extension DefaultTitleValueSliderViewModel {
    static let price = DefaultTitleValueSliderViewModel(
        title: "Kjøpesum:", minimumValue: 0, maximumValue: 5600000, initialValue: 5600000
    )

    static let ownedAmount = DefaultTitleValueSliderViewModel(
        title: "Egenkapital:", minimumValue: 0, maximumValue: 5600000, initialValue: Int(5600000 * 0.35)
    )

    static let paymentYears = DefaultTitleValueSliderViewModel(
        title: "Nedbetalingstid:", minimumValue: 0, maximumValue: 35, initialValue: 25
    )
}

struct DefaultLoanApplyViewModel: LoanApplyViewModel {
    let conditionsText: String
    let applyText: String
}

extension DefaultLoanApplyViewModel {
    static let test = DefaultLoanApplyViewModel(
        conditionsText: "Eff.rente 2,62 %. Etableringsgebyr. 2 500 kr. 4 433 000 kr o/25 år. Kostnad: 1 589 500 kr. Totalt: 6 022 500 kr.",
        applyText: "Søk boliglån"
    )
}
