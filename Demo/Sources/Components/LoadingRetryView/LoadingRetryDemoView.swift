import FinniversKit

final class LoadingRetryDemoView: UIView, Tweakable {
    private lazy var loadingRetryView: LoadingRetryView = {
        let view = LoadingRetryView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Label and button", action: { [weak self] in
            self?.loadingRetryView.state = .labelAndButton
        }),
        TweakingOption(title: "Loading", action: { [weak self] in
            self?.loadingRetryView.state = .loading
        }),
        TweakingOption(title: "Hidden", action: { [weak self] in
            self?.loadingRetryView.state = .hidden
        })
    ]

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(loadingRetryView)

        NSLayoutConstraint.activate([
            loadingRetryView.leadingAnchor.constraint(equalTo: leadingAnchor),
            loadingRetryView.trailingAnchor.constraint(equalTo: trailingAnchor),
            loadingRetryView.centerYAnchor.constraint(equalTo: centerYAnchor),
            loadingRetryView.heightAnchor.constraint(equalToConstant: 200)
        ])

        loadingRetryView.set(labelText: "Vi klarte dessverre ikke å laste dine anbefalinger.", buttonText: "Prøv igjen")
        loadingRetryView.state = .labelAndButton
    }
}

// MARK: - LoadingRetryViewDelegate

extension LoadingRetryDemoView: LoadingRetryViewDelegate {
    func loadingRetryViewDidSelectButton(_ view: LoadingRetryView) {
        print("Tapped retry button!")
    }
}
