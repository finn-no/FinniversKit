import FinniversKit
import DemoKit

final class LoadingRetryDemoView: UIView {
    private lazy var loadingRetryView: LoadingRetryView = {
        let view = LoadingRetryView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configure(forTweakAt: 0)
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
    }
}

extension LoadingRetryDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case labelAndButton
        case loading
        case hidden
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .labelAndButton:
            loadingRetryView.state = .labelAndButton
        case .loading:
            loadingRetryView.state = .loading
        case .hidden:
            loadingRetryView.state = .hidden
        }
    }
}

// MARK: - LoadingRetryViewDelegate

extension LoadingRetryDemoView: LoadingRetryViewDelegate {
    func loadingRetryViewDidSelectButton(_ view: LoadingRetryView) {
        print("Tapped retry button!")
    }
}
