import DemoKit
import FinniversKit

final class FrontPageTransactionDemoView: UIView, Demoable {
    private lazy var frontPageTransactionView: FrontPageTransactionView = {
        let view = FrontPageTransactionView(withAutoLayout: true)
        view.delegate = self
        view.configure(with: .tjtRegular, andImageDatasource: self)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        configure(forTweakAt: 0)
        addSubview(frontPageTransactionView)
        NSLayoutConstraint.activate([
            frontPageTransactionView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            frontPageTransactionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            frontPageTransactionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM)
        ])
    }
}

extension FrontPageTransactionDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case regular
        case longText
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .regular:
            frontPageTransactionView.configure(with: .tjtRegular, andImageDatasource: self)
        case .longText:
            frontPageTransactionView.configure(with: .tjtLong, andImageDatasource: self)
        }
    }
}

// MARK: - FrontPageSavedSearchesViewDelegate

extension FrontPageTransactionDemoView: FrontPageTransactionViewDelegate {
    func transactionViewTapped(_ transactionView: FrontPageTransactionView) {
        print("Tap transaction view")
    }
}

// MARK: - RemoteImageViewDataSource

extension FrontPageTransactionDemoView: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        completion(nil)
    }

    func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}

    @MainActor
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        return nil
    }
}
