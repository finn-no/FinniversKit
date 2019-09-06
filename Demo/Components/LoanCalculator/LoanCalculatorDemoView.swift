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
        loanCalculatorView.configure(with: DefaultLoanCalculatorViewModel.makeViewModel())
        addSubview(loanCalculatorView)
        NSLayoutConstraint.activate([
            loanCalculatorView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1, constant: -.largeSpacing),
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

        let viewModel = DefaultLoanCalculatorViewModel.makeViewModel(price: Int(price), hasConditions: Bool.random())
        finishLoading(with: viewModel)
    }

    func loanValuesView(_ view: LoanCalculatorView, didChangeEquity equity: Float) {
        print("Equity changed: \(equity)")

        let viewModel = DefaultLoanCalculatorViewModel.makeViewModel(equity: Int(equity))
        finishLoading(with: viewModel)
    }

    func loanValuesView(_ view: LoanCalculatorView, didChangePaymentYears years: Int) {
        print("Payment years changed: \(years)")

        let viewModel = DefaultLoanCalculatorViewModel.makeViewModel(equity: Int(years))
        finishLoading(with: viewModel)
    }

    func loanValuesViewDidSelectApply(_ view: LoanCalculatorView) {
        print("Apply button selected")
    }

    private func finishLoading(with viewModel: LoanCalculatorViewModel) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) { [weak self] in
            self?.loanCalculatorView.isLoading = false
            self?.loanCalculatorView.configure(with: viewModel)
        }
    }
}

// MARK: - Private types

private struct DefaultLoanCalculatorViewModel: LoanCalculatorViewModel {
    let title: String?
    let rentText: String?
    let pricePerMonth: String?
    let loanAmountText: String?
    let logoUrl: String?
    let conditionsText: String
    let applyText: String
    var price: TitleValueSliderViewModel
    var equity: TitleValueSliderViewModel
    var paymentYears: TitleValueSliderViewModel
}

extension DefaultLoanCalculatorViewModel {
    static func makeViewModel(
        price: Int = 5600000,
        equity: Int = Int((5600000 - 10000) * 0.35),
        paymentYears: Int = 25,
        hasConditions: Bool = true
    ) -> DefaultLoanCalculatorViewModel {
        let conditionsText = hasConditions
            ? "Eff.rente 2,62 %. Etableringsgebyr. 2 500 kr. 4 433 000 kr o/25 år. Kostnad: 1 589 500 kr. Totalt: 6 022 500 kr."
            :"Verdiene er utenfor banks prisliste. Renten vil dermed settes på individuell basis"

        return DefaultLoanCalculatorViewModel(
            title: hasConditions ? "Estimert pr. måned" : nil,
            rentText: hasConditions ? "2,65 % eff. / 2,55 % nom. rente" : nil,
            pricePerMonth: hasConditions ? "16 656 kr" : nil,
            loanAmountText: hasConditions ? "Lånesum: 3 675 000 kr": nil,
            logoUrl: "https://static.finncdn.no/_c/pf-logos/dnbnor_logo.png",
            conditionsText: conditionsText,
            applyText: "Søk boliglån",
            price: DefaultTitleValueSliderViewModel.makePrice(withInitialValue: price),
            equity: DefaultTitleValueSliderViewModel.makeEquity(withInitialValue: equity),
            paymentYears: DefaultTitleValueSliderViewModel.makePaymentYears(withInitialValue: paymentYears)
        )
    }
}

struct DefaultTitleValueSliderViewModel: TitleValueSliderViewModel {
    let title: String
    let minimumValue: Int
    let maximumValue: Int
    let initialValue: Int
}

extension DefaultTitleValueSliderViewModel {
    static func makePrice(withInitialValue value: Int) -> DefaultTitleValueSliderViewModel {
        return DefaultTitleValueSliderViewModel(
            title: "Kjøpesum:",
            minimumValue: 0,
            maximumValue: 5600000,
            initialValue: value
        )
    }

    static func makeEquity(withInitialValue value: Int) -> DefaultTitleValueSliderViewModel {
        return DefaultTitleValueSliderViewModel(
            title: "Egenkapital:",
            minimumValue: 0,
            maximumValue: 5600000 - 10000,
            initialValue: value
        )
    }

    static func makePaymentYears(withInitialValue value: Int) -> DefaultTitleValueSliderViewModel {
        return DefaultTitleValueSliderViewModel(
            title: "Nedbetalingstid:",
            minimumValue: 5,
            maximumValue: 30,
            initialValue: value
        )
    }
}
