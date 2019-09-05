//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import FinniversKit

class LoanCalculatorDemoView: UIView {
    private lazy var loanCalculatorView: LoanCalculatorView = {
        let view = LoanCalculatorView(withAutoLayout: true)
        view.dataSource = self
        view.delegate = self
        view.layer.cornerRadius = .mediumSpacing
        return view
    }()

    private lazy var currencyFormatter: IntegerNumberSuffixFormatter = IntegerNumberSuffixFormatter(suffix: "kr")
    private lazy var yearsFormatter: IntegerNumberSuffixFormatter = IntegerNumberSuffixFormatter(suffix: "år")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        loanCalculatorView.configure(with: DefaultLoanCalculatorViewModel.test)
        addSubview(loanCalculatorView)
        NSLayoutConstraint.activate([
            loanCalculatorView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 1, constant: -.largeSpacing),
            loanCalculatorView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 1, constant: -.largeSpacing),
            loanCalculatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loanCalculatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

// MARK: - LoanCalculatorDataSource

extension LoanCalculatorDemoView: LoanCalculatorDataSource {
    func loanCalculatorView(_ view: LoanCalculatorView, formattedCurrencyValue value: Float) -> String? {
        return currencyFormatter.string(for: value)
    }

    func loanCalculatorView(_ view: LoanCalculatorView, formattedYearsValue value: Int) -> String? {
        return yearsFormatter.string(for: Float(value))
    }

    func loanCalculatorView(
        _ view: LoanCalculatorView,
        loadImageWithPath imagePath: String,
        imageWidth: CGFloat,
        completion: @escaping ((UIImage?) -> Void)
    ) {
        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

        // Demo code only.
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            usleep(50_000)
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }

        task.resume()
    }

    func loanCalculatorView(_ view: LoanCalculatorView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}

// MARK: - LoanCalculatorDelegate

extension LoanCalculatorDemoView: LoanCalculatorDelegate {
    func loanValuesView(_ view: LoanCalculatorView, didChangePrice price: Float) {
        print("Price changes: \(price)")
        finishLoading()
    }

    func loanValuesView(_ view: LoanCalculatorView, didChangeEquity equity: Float) {
        print("Equity changed: \(equity)")
        finishLoading()
    }

    func loanValuesView(_ view: LoanCalculatorView, didChangePaymentYears years: Int) {
        print("Payment years changed: \(years)")
        finishLoading()
    }

    func loanValuesViewDidSelectApply(_ view: LoanCalculatorView) {
        print("Apply button selected")
    }

    private func finishLoading() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) { [weak self] in
            self?.loanCalculatorView.isLoading = false
            self?.loanCalculatorView.showErrorText(Bool.random())
        }
    }
}

struct DefaultLoanCalculatorViewModel: LoanCalculatorViewModel {
    let title: String
    let rentText: String
    let pricePerMonth: String
    let loanAmountText: String
    let logoUrl: String?
    let errorText: String
    let conditionsText: String
    let applyText: String
    var price: TitleValueSliderViewModel
    var equity: TitleValueSliderViewModel
    var paymentYears: TitleValueSliderViewModel
}

extension DefaultLoanCalculatorViewModel {
    static let test = DefaultLoanCalculatorViewModel(
        title: "Estimert pr. måned",
        rentText: "2,65 % eff. / 2,55 % nom. rente",
        pricePerMonth: "16 656 kr",
        loanAmountText: "Lånesum: 3 675 000 kr",
        logoUrl: "https://static.finncdn.no/_c/pf-logos/dnbnor_logo.png",
        errorText: "Verdiene er utenfor banks prisliste. Renten vil dermed settes på individuell basis",
        conditionsText: "Eff.rente 2,62 %. Etableringsgebyr. 2 500 kr. 4 433 000 kr o/25 år. Kostnad: 1 589 500 kr. Totalt: 6 022 500 kr.",
        applyText: "Søk boliglån",
        price: DefaultTitleValueSliderViewModel.price,
        equity: DefaultTitleValueSliderViewModel.equity,
        paymentYears: DefaultTitleValueSliderViewModel.paymentYears
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

    static let equity = DefaultTitleValueSliderViewModel(
        title: "Egenkapital:", minimumValue: 0, maximumValue: 5600000 - 10000, initialValue: Int((5600000 - 10000) * 0.35)
    )

    static let paymentYears = DefaultTitleValueSliderViewModel(
        title: "Nedbetalingstid:", minimumValue: 5, maximumValue: 30, initialValue: 25
    )
}
