import FinniversKit

class ContractActionDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption]  = [
        TweakingOption(title: "Basic", action: { [weak self] in
            self?.contractActionView.configure(with: .default)
        }),
        TweakingOption(title: "Car contract", action: { [weak self] in
            self?.contractActionView.configure(
                with: .carContract,
                trailingImage: UIImage(named: .carsCircleIllustration),
                paragraphSpacing: 12
            )
        }),
        TweakingOption(title: "Request access to contract", action: { [weak self] in
            self?.contractActionView.configure(
                with: .requestAccessToContract,
                trailingImage: UIImage(named: .contract),
                trailingImageTopConstant: .spacingM,
                trailingImageTrailingConstant: -.spacingM,
                contentSpacing: .spacingM,
                paragraphSpacing: 12
            )
        })
    ]

    private lazy var contractActionView: ContractActionView = {
        let view = ContractActionView(withAutoLayout: true)
        view.delegate = self
        view.configure(with: .default)
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(contractActionView)

        NSLayoutConstraint.activate([
            contractActionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
            contractActionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            contractActionView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

extension ContractActionDemoView: ContractActionViewDelegate {
    func contractActionView(_ view: ContractActionView, didSelectActionButtonWithUrl url: URL) {
        print("🔥🔥🔥🔥 \(#function)")
    }
}

private extension ContractActionViewModel {
    static let `default`: ContractActionViewModel = ContractActionViewModel(
        identifier: "demo-view",
        strings: [
            "Godkjent kontrakt av Forbrukerrådet",
            "Enkelt og trygt for begge parter",
            "Oversikt over hele prosessen",
            "Mulighet for gratis forsikring i 30 dager til 0 kr"
        ],
        buttonTitle: "Få ferdig utfylt kontrakt",
        buttonUrl: URL(string: "https://www.finn.no/")!
    )

    static let carContract: ContractActionViewModel = ContractActionViewModel(
        title: "Smidig bilhandel?",
        subtitle: "FINN guider deg hele veien.",
        identifier: "demo-view",
        strings: [
            "Godkjent kontrakt av Forbrukerrådet",
            "Enkelt og trygt for begge parter",
            "Oversikt over hele prosessen",
            "Mulighet for gratis forsikring i 30 dager til 0 kr"
        ],
        buttonTitle: "Få ferdig utfylt kontrakt",
        buttonUrl: URL(string: "https://www.finn.no/")!
    )

    static let requestAccessToContract: ContractActionViewModel = ContractActionViewModel(
        title: "Smidig bilhandel",
        subtitle: "FINN guider deg hele veien.",
        description: "Selger har opprettet\nkjøpekontrakt for denne bilen",
        identifier: "demo-view",
        strings: [
            "Godkjent kontrakt av Forbrukerrådet",
            "Enkelt og trygt for begge parter",
            "Oversikt over hele prosessen",
            "Mulighet for gratis forsikring i 30 dager til 0 kr"
        ],
        buttonTitle: "Be selger om tilgang til kontrakten",
        buttonUrl: URL(string: "https://www.finn.no/")!
    )
}
