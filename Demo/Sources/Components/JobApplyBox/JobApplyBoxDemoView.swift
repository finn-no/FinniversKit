import FinniversKit

class JobApplyBoxDemoView: UIView, Tweakable {

    lazy var tweakingOptions: [TweakingOption] = [
        .init(title: "Default", action: { [weak self] in
            self?.configure(viewModel: .default)
        }),
        .init(title: "Without secondary button", action: { [weak self] in
            self?.configure(viewModel: .withoutSecondary)
        })
    ]

    // MARK: - Private properties

    private var demoView: JobApplyBoxView?

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        tweakingOptions.first?.action?()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Private methods

    func configure(viewModel: JobApplyBoxViewModel) {
        demoView?.removeFromSuperview()

        let demoView = JobApplyBoxView(viewModel: viewModel, delegate: self, withAutoLayout: true)
        addSubview(demoView)
        NSLayoutConstraint.activate([
            demoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            demoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            demoView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        self.demoView = demoView
    }
}

// MARK: - JobApplyBox

extension JobApplyBoxDemoView: JobApplyBoxViewDelegate {
    func jobApplyBoxView(
        _ view: JobApplyBoxView,
        didSelectButton selectedButton: JobApplyBoxView.SelectedButton,
        withURL url: URL
    ) {
        print("👉 Did select button: \(selectedButton)")
    }
}

// MARK: - Private extensions

private extension JobApplyBoxViewModel {
    static var `default`: Self {
        JobApplyBoxViewModel(
            title: "Denne annonsen er hentet fra XYZ/arbeidssted.no",
            primaryButton: .primary,
            secondaryButton: .secondary
        )
    }

    static var withoutSecondary: Self {
        JobApplyBoxViewModel(
            title: "Denne annonsen er hentet fra XYZ/arbeidssted.no",
            primaryButton: .primary
        )
    }
}

private extension JobApplyBoxViewModel.Button {
    static var primary: Self {
        Self.init(title: "Søk her", url: URL(string: "https://finn.no")!)
    }

    static var secondary: Self {
        Self.init(title: "Se fullstendig annonse", url: URL(string: "https://finn.no")!)
    }
}
