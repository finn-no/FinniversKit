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
            priceView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            priceView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            priceView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

extension ObjectPagePriceDemoView: ObjectPagePriceViewDelegate {
    func priceView(_ view: ObjectPagePriceView, didTapLinkWithUrl url: URL) {
        print("🔥🔥🔥🔥 \(#function) - url: \(url)")
    }
}

extension ObjectPagePriceViewModel {
    static var `withLinks`: ObjectPagePriceViewModel = {
        ObjectPagePriceViewModel(
            title: "Totalpris",
            totalPrice: "1 389 588 kr",
            links: [
                LinkButtonViewModel(
                    buttonTitle: "Lån fra 16 581 kr",
                    subtitle: "Eff.rente 3,89 %. 903 232 o/5 år. Kostnad: 91 628 kr. Totalt 994 860 kr.",
                    linkUrl: URL(string: "https://www.finn.no/")!
                ),
                LinkButtonViewModel(
                    buttonTitle: "Pris på forsikring",
                    linkUrl: URL(string: "https://www.finn.no/")!
                ),
                LinkButtonViewModel(
                    buttonTitle: "Bruktbilgaranti 272 kr",
                    linkUrl: URL(string: "https://www.finn.no/")!
                )
            ]
        )
    }()

    static var `withoutLinks`: ObjectPagePriceViewModel = {
        ObjectPagePriceViewModel(
            title: "Totalpris",
            totalPrice: "1 389 588 kr",
            links: []
        )
    }()
}
