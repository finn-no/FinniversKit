import FinniversKit

final class FrontPageTransactionDemoView: UIView, Tweakable {
    var modelRegular: FrontPageTransactionViewModel {
        .init(
            id: "tjt",
            headerTitle: "Fiks ferdig",
            title: "Gjør klar til sending",
            subtitle: "Velg en kjøper",
            imageUrl: nil,
            adId: 1234,
            transactionId: "123-456-789"
        )
    }

    var modelLongText: FrontPageTransactionViewModel {
        .init(
            id: "tjt",
            headerTitle: "Fiks ferdig Fiks ferdig Fiks ferdig Fiks ferdig Fiks ferdig Fiks ferdig Fiks ferdig",
            title: "Gjør klar til sending. Gjør klar til sending. Gjør klar til sending. Gjør klar til sending. Gjør klar til sending. Gjør klar til sending. Gjør klar til sending. Gjør klar til sending.",
            subtitle: "Velg en kjøper. Velg en kjøper. Velg en kjøper. Velg en kjøper. Velg en kjøper. Velg en kjøper. Velg en kjøper. Velg en kjøper. Velg en kjøper. Velg en kjøper. Velg en kjøper.",
            imageUrl: nil,
            adId: 1234,
            transactionId: "123-456-789"
        )
    }

    lazy var tweakingOptions: [TweakingOption] = [
        .init(title: "Regular") { [weak self] in
            guard let self else { return }
            self.frontPageTransactionView.configure(with: modelRegular, andImageDatasource: self)
        },
        .init(title: "Long text") { [weak self] in
            guard let self else { return }
            self.frontPageTransactionView.configure(with: modelLongText, andImageDatasource: self)
        }
    ]

    private lazy var frontPageTransactionView: FrontPageTransactionView = {
        let view = FrontPageTransactionView(withAutoLayout: true)
        view.delegate = self
        view.configure(with: modelRegular, andImageDatasource: self)
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
        addSubview(frontPageTransactionView)
        NSLayoutConstraint.activate([
            frontPageTransactionView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            frontPageTransactionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            frontPageTransactionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM)
        ])
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
