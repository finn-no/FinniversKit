import UIKit

public final class FrontPageTransactionListView: UIStackView {
    public private(set) var viewModels: [FrontPageTransactionViewModel] = []

    public override init(frame: CGRect) {
        super.init(frame: frame)
        axis = .vertical
        distribution = .fillProportionally
        spacing = .spacingL
    }

    public convenience init(frame: CGRect, withAutoLayout: Bool = false) {
        self.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(
        viewModels: [FrontPageTransactionViewModel],
        delegate: FrontPageTransactionViewDelegate?,
        imageViewDataSource: RemoteImageViewDataSource
    ) {
        removeArrangedSubviews()
        let views = viewModels.map { viewModel in
            let view = FrontPageTransactionView(withAutoLayout: true)
            view.configure(with: viewModel, andImageDatasource: imageViewDataSource)
            view.delegate = delegate
            return view
        }
        addArrangedSubviews(views)
    }
}
