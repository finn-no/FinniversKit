import FinniversKit

final class FrontPageTransactionListDemoView: UIView {
    private lazy var frontPageTransactionListView: FrontPageTransactionListView = {
        let view = FrontPageTransactionListView(frame: .zero, withAutoLayout: true)
        view.configure(
            viewModels: [.tjtRegular, .tjmRegular],
            delegate: self,
            imageViewDataSource: self
        )
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
        addSubview(frontPageTransactionListView)
        NSLayoutConstraint.activate([
            frontPageTransactionListView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            frontPageTransactionListView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            frontPageTransactionListView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM)
        ])
    }
}

// MARK: - FrontPageSavedSearchesViewDelegate

extension FrontPageTransactionListDemoView: FrontPageTransactionViewDelegate {
    func transactionViewTapped(_ transactionView: FrontPageTransactionView) {
        print("Tap transaction view, id: \(String(describing: transactionView.viewModel?.id))")
    }
}

// MARK: - RemoteImageViewDataSource

extension FrontPageTransactionListDemoView: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        completion(nil)
    }

    func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}

    @MainActor
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        return nil
    }
}
