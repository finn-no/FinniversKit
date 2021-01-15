import FinniversKit

class ObjectPagePriceDemoView: UIView, Tweakable {
    private lazy var priceView: ObjectPagePriceView = {
        let view = ObjectPagePriceView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    lazy var tweakingOptions: [TweakingOption] = {
        [
            TweakingOption(title: "With links", action: { [weak self] in
                self?.priceView.configure(with: .withLinks)
            }),

            TweakingOption(title: "Without links", action: { [weak self] in
                self?.priceView.configure(with: .withoutLinks)
            }),

            TweakingOption(title: "Link w/ heading and subheading", action: { [weak self] in
                self?.priceView.configure(with: .loanLinkVariant)
            }),

            TweakingOption(title: "BFFT variant compact (realestate)", action: { [weak self] in
                self?.priceView.configure(with: .bfftVariantCompact)
            }),

            TweakingOption(title: "BFFT variant compact, w/ price details (realestate)", action: { [weak self] in
                self?.priceView.configure(with: .bfftVariantCompactWithPriceDetails)
            }),

            TweakingOption(title: "With subtitle & links", action: { [weak self] in
                self?.priceView.configure(with: .subtitleWithLinks)
            }),

            TweakingOption(title: "With subtitle, without links", action: { [weak self] in
                self?.priceView.configure(with: .subtitleWithoutLinks)
            }),

            TweakingOption(title: "With seconday price & links", action: { [weak self] in
                self?.priceView.configure(with: .secondaryPrice)
            }),

            TweakingOption(title: "Main price only", action: { [weak self] in
                self?.priceView.configure(with: .mainPriceOnly, style: .init(priceStyle: .title1))
            }),

            TweakingOption(title: "BAP for sale", action: { [weak self] in
                self?.priceView.configure(with: .bapSaleAd)
            }),

            TweakingOption(title: "BAP wanted", action: { [weak self] in
                self?.priceView.configure(with: .bapWantedAd)
            }),

            TweakingOption(title: "BAP wanted w/ max price", action: { [weak self] in
                self?.priceView.configure(with: .bapWantedWithMaxPriceAd)
            }),

            TweakingOption(title: "Realestate: New construction", action: { [weak self] in
                self?.priceView.configure(with: .newConstruction)
            })
        ]
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        priceView.configure(with: .withLinks)

        addSubview(priceView)
        NSLayoutConstraint.activate([
            priceView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            priceView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            priceView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

extension ObjectPagePriceDemoView: ObjectPagePriceViewDelegate {
    func priceView(_ view: ObjectPagePriceView, didTapLinkButtonWithIdentifier identifier: String?, url: URL) {
        print("🔥🔥🔥🔥 \(#function) - buttonIdentifier: \(identifier ?? "") - url: \(url)")
    }
}

extension ObjectPagePriceViewModel {
    static var withLinks: ObjectPagePriceViewModel = {
        ObjectPagePriceViewModel(
            title: "Totalpris",
            totalPrice: "1 389 588 kr",
            accessibilityLabel: "Totalpris: \(NumberFormatter.spokenFormatter.string(from: 1389588) ?? String(1389588)) kroner",
            links: [
                PriceLinkButtonViewModel(
                    buttonIdentifier: "loan",
                    buttonTitle: "Lån fra 16 581 kr",
                    subtitle: "Eff.rente 3,89 %. 903 232 o/5 år. Kostnad: 91 628 kr. Totalt 994 860 kr.",
                    linkUrl: URL(string: "https://www.finn.no/")!,
                    isExternal: true
                ),
                PriceLinkButtonViewModel(
                    buttonIdentifier: "insurance",
                    buttonTitle: "Pris på forsikring",
                    linkUrl: URL(string: "https://www.finn.no/")!,
                    isExternal: false
                ),
                PriceLinkButtonViewModel(
                    buttonIdentifier: "used-car-guarantee",
                    buttonTitle: "Bruktbilgaranti 272 kr",
                    linkUrl: URL(string: "https://www.finn.no/")!,
                    isExternal: true
                )
            ]
        )
    }()

    static var subtitleWithLinks: ObjectPagePriceViewModel = {
        ObjectPagePriceViewModel(
            title: "Totalpris",
            totalPrice: "1 389 588 kr",
            subtitle: "Inkludert alle klargjøringskostnader",
            links: [
                PriceLinkButtonViewModel(
                    buttonIdentifier: "loan",
                    buttonTitle: "Lån fra 16 581 kr",
                    subtitle: "Eff.rente 3,89 %. 903 232 o/5 år. Kostnad: 91 628 kr. Totalt 994 860 kr.",
                    linkUrl: URL(string: "https://www.finn.no/")!,
                    isExternal: true
                ),
                PriceLinkButtonViewModel(
                    buttonIdentifier: "insurance",
                    buttonTitle: "Pris på forsikring",
                    linkUrl: URL(string: "https://www.finn.no/")!,
                    isExternal: false
                ),
                PriceLinkButtonViewModel(
                    buttonIdentifier: "used-car-guarantee",
                    buttonTitle: "Bruktbilgaranti 272 kr",
                    linkUrl: URL(string: "https://www.finn.no/")!,
                    isExternal: true
                )
            ]
        )
    }()

    static var loanLinkVariant: ObjectPagePriceViewModel = {
        ObjectPagePriceViewModel(
            title: "Totalpris",
            totalPrice: "1 389 588 kr",
            subtitle: "Inkludert alle klargjøringskostnader",
            links: [
                PriceLinkButtonViewModel(
                    buttonIdentifier: "loan",
                    buttonTitle: "Se alle lånetilbudene",
                    subtitle: "Eff.rente 3,89 %. 903 232 o/5 år. Kostnad: 91 628 kr. Totalt 994 860 kr.",
                    heading: "Pris på lån",
                    subheading: "fra 16 581 kr",
                    linkUrl: URL(string: "https://www.finn.no/")!,
                    isExternal: true,
                    kind: .variantFull
                ),
                PriceLinkButtonViewModel(
                    buttonIdentifier: "insurance",
                    buttonTitle: "Pris på forsikring",
                    linkUrl: URL(string: "https://www.finn.no/")!,
                    isExternal: false
                ),
                PriceLinkButtonViewModel(
                    buttonIdentifier: "used-car-guarantee",
                    buttonTitle: "Bruktbilgaranti 272 kr",
                    linkUrl: URL(string: "https://www.finn.no/")!,
                    isExternal: true
                )
            ]
        )
    }()

    static var bfftVariantCompact: ObjectPagePriceViewModel = {
        ObjectPagePriceViewModel(
            title: "Prisantydning",
            totalPrice: "1 389 588 kr",
            links: [
                PriceLinkButtonViewModel(
                    buttonIdentifier: "loan",
                    buttonTitle: "fra 8 098 kr/mnd",
                    subtitle: "Eff.rente 3,89 %. 903 232 o/5 år. Kostnad: 91 628 kr. Totalt 994 860 kr.",
                    subheading: "Pris på lån:",
                    linkUrl: URL(string: "https://www.finn.no/")!,
                    isExternal: true,
                    kind: .variantCompact
                ),
                PriceLinkButtonViewModel(
                    buttonIdentifier: "insurance",
                    buttonTitle: "Pris på forsikring",
                    linkUrl: URL(string: "https://www.finn.no/")!,
                    isExternal: false
                ),
                PriceLinkButtonViewModel(
                    buttonIdentifier: "used-car-guarantee",
                    buttonTitle: "Bruktbilgaranti 272 kr",
                    linkUrl: URL(string: "https://www.finn.no/")!,
                    isExternal: true
                )
            ]
        )
    }()

    static var bfftVariantCompactWithPriceDetails: ObjectPagePriceViewModel = {
        ObjectPagePriceViewModel(
            title: "Prisantydning",
            totalPrice: "1 389 588 kr",
            links: [
                PriceLinkButtonViewModel(
                    buttonIdentifier: "loan",
                    buttonTitle: "fra 8 098 kr/mnd",
                    subtitle: "Eff.rente 3,89 %. 903 232 o/5 år. Kostnad: 91 628 kr. Totalt 994 860 kr.",
                    subheading: "Pris på lån:",
                    linkUrl: URL(string: "https://www.finn.no/")!,
                    isExternal: true,
                    kind: .variantCompact
                ),
                PriceLinkButtonViewModel(
                    buttonIdentifier: "insurance",
                    buttonTitle: "Pris på forsikring",
                    linkUrl: URL(string: "https://www.finn.no/")!,
                    isExternal: false
                ),
                PriceLinkButtonViewModel(
                    buttonIdentifier: "used-car-guarantee",
                    buttonTitle: "Bruktbilgaranti 272 kr",
                    linkUrl: URL(string: "https://www.finn.no/")!,
                    isExternal: true
                )
            ],
            priceDetails: [
                KeyValuePair(title: "Omkostninger", value: "77 792 kr"),
                KeyValuePair(title: "Totalpris", value: "2 727 792 kr"),
                KeyValuePair(title: "Felleskost/mnd.", value: "2 728 kr")
            ]
        )
    }()

    static var withoutLinks: ObjectPagePriceViewModel = {
        ObjectPagePriceViewModel(
            title: "Totalpris",
            totalPrice: "1 389 588 kr"
        )
    }()

    static var subtitleWithoutLinks: ObjectPagePriceViewModel = {
        ObjectPagePriceViewModel(
            title: "Totalpris",
            totalPrice: "1 389 588 kr",
            subtitle: "Inkludert alle klargjøringskostnader"
        )
    }()

    static var secondaryPrice: ObjectPagePriceViewModel = {
        ObjectPagePriceViewModel(
            mainPriceModel: Price(title: "Månedspris", totalPrice: "3950 kr"),
            secondaryPriceModel: Price(title: "Innskudd", totalPrice: "120 000 kr"),
            links: [
                PriceLinkButtonViewModel(
                    buttonIdentifier: "insurance",
                    buttonTitle: "Pris på forsikring",
                    linkUrl: URL(string: "https://www.finn.no/")!,
                    isExternal: false
                )
            ]
        )
    }()

    static var mainPriceOnly: ObjectPagePriceViewModel = {
        ObjectPagePriceViewModel(totalPrice: "1 389 588 kr")
    }()

    static var bapSaleAd: ObjectPagePriceViewModel = {
        ObjectPagePriceViewModel(
            totalPrice: "1 500 kr",
            adTypeText: "Til salgs"
        )
    }()

    static var bapWantedAd: ObjectPagePriceViewModel = {
        ObjectPagePriceViewModel(
            adTypeText: "Ønskes kjøpt"
        )
    }()

    static var bapWantedWithMaxPriceAd: ObjectPagePriceViewModel = {
        ObjectPagePriceViewModel(
            title: "Makspris",
            totalPrice: "5 500 kr",
            adTypeText: "Ønskes kjøpt"
        )
    }()

    static var newConstruction: ObjectPagePriceViewModel = {
        ObjectPagePriceViewModel(
            title: "Pris",
            totalPrice: "4 800 000 - 5 919 000 kr",
            priceDetails: [
                KeyValuePair(title: "Totalpris", value: "5 000 000 - 6 120 000 kr")
            ],
            priceDetailsNumberOfColumns: 1
        )
    }()
}

private extension NumberFormatter {
    static var spokenFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .spellOut
        formatter.locale = Locale(identifier: "nb_NO")
        return formatter
    }()
}
