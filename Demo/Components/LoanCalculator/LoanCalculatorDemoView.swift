//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import FinniversKit

struct LoanCalculatorDemoViewModel: LoanCalculatorViewModel {
    var title: String?
    var rentText: String?
    var pricePerMonth: String?
    var loanAmountText: String?
    var logoUrl: URL?
    var accentColor: UIColor?
    var conditionsText: String?
    var errorText: String?
    var applyText: String
    var price: TitleValueSliderViewModel
    var equity: TitleValueSliderViewModel
    var paymentYears: TitleValueSliderViewModel
}

class LoanCalculatorDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption] = {
        let options = [
            TweakingOption(title: "Normal view model", action: {
                self.loanCalculatorView.configure(with: LoanCalculatorDemoViewModel.makeViewModel())
            }),
            TweakingOption(title: "Nordea", action: {
                self.loanCalculatorView.configure(with: LoanCalculatorDemoViewModel.makeViewModel(bank: LoanCalculatorDemoViewModel.DemoCases.nordea))
            }),
            TweakingOption(title: "Danske bank", action: {
                self.loanCalculatorView.configure(with: LoanCalculatorDemoViewModel.makeViewModel(bank: LoanCalculatorDemoViewModel.DemoCases.danskeBank))
            }),
            TweakingOption(title: "Nominal Rate missing error", action: {
                self.loanCalculatorView.configure(with: LoanCalculatorDemoViewModel.makeViewModel(hasConditions: false))
            }),
        ]
        return options
    }()

    private lazy var loanCalculatorView: LoanCalculatorView = {
        let view = LoanCalculatorView(withAutoLayout: true)
        view.dataSource = self
        view.delegate = self
        return view
    }()

    private lazy var currencyFormatter = IntegerNumberSuffixFormatter(suffix: "kr")
    private lazy var yearsFormatter = IntegerNumberSuffixFormatter(suffix: "år")

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        loanCalculatorView.configure(with: LoanCalculatorDemoViewModel.makeViewModel())
        addSubview(loanCalculatorView)
        NSLayoutConstraint.activate([
            loanCalculatorView.widthAnchor.constraint(equalTo: widthAnchor, constant: -.largeSpacing),
            loanCalculatorView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, constant: -.largeSpacing),
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
        loadImageWithUrl url: URL,
        completion: @escaping ((UIImage?) -> Void)
    ) {
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

    func loanCalculatorView(_ view: LoanCalculatorView, cancelLoadingImageWithUrl: URL) {}
}

// MARK: - LoanCalculatorDelegate

extension LoanCalculatorDemoView: LoanCalculatorDelegate {
    func loanValuesView(_ view: LoanCalculatorView, didChangePrice price: Float) {
        print("Price changes: \(price)")

        let viewModel = LoanCalculatorDemoViewModel.makeViewModel(price: Int(price), hasConditions: Bool.random())
        finishLoading(with: viewModel)
    }

    func loanValuesView(_ view: LoanCalculatorView, didChangeEquity equity: Float) {
        print("Equity changed: \(equity)")

        let viewModel = LoanCalculatorDemoViewModel.makeViewModel(equity: Int(equity))
        finishLoading(with: viewModel)
    }

    func loanValuesView(_ view: LoanCalculatorView, didChangePaymentYears years: Int) {
        print("Payment years changed: \(years)")

        let viewModel = LoanCalculatorDemoViewModel.makeViewModel(equity: Int(years))
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

// MARK: - Private extensions

extension LoanCalculatorDemoViewModel {
    enum DemoCases {
        case dnb
        case nordea
        case danskeBank

        var logoURL: URL? {
            switch self {
            case .dnb: return URL(string: "https://static.finncdn.no/_c/pf-logos/dnbnor_logo.png")
            case .danskeBank: return URL(string: "https://www.finn.no/pf-logos/danske_bank")
            case .nordea: return URL(string: "https://www.finn.no/pf-logos/nordea")
            }
        }

        var accentColor: UIColor? {
            switch self {
            case .dnb: return UIColor.dynamicColorIfAvailable(
                defaultColor: UIColor(r: 55, g: 122, b: 130)!,
                darkModeColor: UIColor(r: 58, g: 168, b: 180)!
            )
            case .nordea: return UIColor.dynamicColorIfAvailable(
                defaultColor: UIColor(r: 0, g: 0, b: 160)!,
                darkModeColor: UIColor(r: 49, g: 49, b: 211)!
            )
            case .danskeBank: return UIColor.dynamicColorIfAvailable(
                defaultColor: UIColor(r: 0, g: 55, b: 85)!,
                darkModeColor: UIColor(r: 22, g: 92, b: 129)!
            )
            }
        }
    }

    static func makeViewModel(
        price: Int = 5600000,
        equity: Int = Int((5600000 - 10000) * 0.35),
        paymentYears: Int = 25,
        bank: DemoCases = .dnb,
        hasConditions: Bool = true
    ) -> LoanCalculatorDemoViewModel {
        let conditionsText = hasConditions
            ? "Eff.rente 2,62 %. Etableringsgebyr. 2 500 kr. 4 433 000 kr o/25 år. Kostnad: 1 589 500 kr. Totalt: 6 022 500 kr."
            : "Verdiene er utenfor banks prisliste. Renten vil dermed settes på individuell basis"

        return LoanCalculatorDemoViewModel(
            title: hasConditions ? "Estimert pr. måned" : nil,
            rentText: hasConditions ? "2,65 % eff. / 2,55 % nom. rente" : nil,
            pricePerMonth: hasConditions ? "16 656 kr" : nil,
            loanAmountText: hasConditions ? "Lånesum: 3 675 000 kr": nil,
            logoUrl: bank.logoURL,
            accentColor: bank.accentColor,
            conditionsText: hasConditions ? conditionsText : nil,
            errorText: hasConditions ? nil : conditionsText,
            applyText: "Søk boliglån",
            price: .makePrice(withInitialValue: price),
            equity: .makeEquity(withInitialValue: equity),
            paymentYears: .makePaymentYears(withInitialValue: paymentYears)
        )
    }
}

extension TitleValueSliderViewModel {
    static func makePrice(withInitialValue value: Int) -> TitleValueSliderViewModel {
        return TitleValueSliderViewModel(
            title: "Kjøpesum:",
            minimumValue: 0,
            maximumValue: 5600000,
            initialValue: value
        )
    }

    static func makeEquity(withInitialValue value: Int) -> TitleValueSliderViewModel {
        return TitleValueSliderViewModel(
            title: "Egenkapital:",
            minimumValue: 0,
            maximumValue: 5600000 - 10000,
            initialValue: value
        )
    }

    static func makePaymentYears(withInitialValue value: Int) -> TitleValueSliderViewModel {
        return TitleValueSliderViewModel(
            title: "Nedbetalingstid:",
            minimumValue: 5,
            maximumValue: 30,
            initialValue: value
        )
    }
}
