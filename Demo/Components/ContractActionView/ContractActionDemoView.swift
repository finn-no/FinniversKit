import FinniversKit

class ContractActionDemoView: UIView {
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
            "Digital signering",
            "Ferdig utfylt kontrakt",
            "1 mnd bilforsikring til kr 0,-"
        ],
        buttonTitle: "Opprett kjøpekontrakt",
        buttonUrl: URL(string: "https://www.finn.no/")!
    )
}
