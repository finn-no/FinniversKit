//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class ImageLinkListView: UIView {

    // MARK: - Private properties

    private weak var delegate: ImageLinkViewDelegate?
    private weak var remoteImageViewDataSource: RemoteImageViewDataSource?
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        return stackView
    }()

    // MARK: - Init

    public init(delegate: ImageLinkViewDelegate, remoteImageViewDataSource: RemoteImageViewDataSource, withAutoLayout: Bool = false) {
        self.delegate = delegate
        self.remoteImageViewDataSource = remoteImageViewDataSource
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(stackView)
        stackView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(with viewModels: [ImageLinkViewModel], groupAxis: NSLayoutConstraint.Axis) {
        stackView.removeArrangedSubviews()

        let stackViewSpacing = CGFloat.spacingM

        let chunked = viewModels.chunked(by: 2)
        let nestedStackViews = chunked.map { models -> UIStackView in
            let views = models.map { viewModel -> ImageLinkView in
                let view = ImageLinkView(withAutoLayout: true)
                view.remoteImageViewDataSource = remoteImageViewDataSource
                view.delegate = delegate
                view.configure(with: viewModel)
                return view
            }

            let nestedStackView = UIStackView(withAutoLayout: true)
            nestedStackView.axis = groupAxis
            nestedStackView.addArrangedSubviews(views)
            nestedStackView.spacing = .spacingM
            nestedStackView.distribution = .fillEqually

            nestedStackView.spacing = stackViewSpacing

            if views.count == 1 && groupAxis == .horizontal {
                let emptyView = UIView(withAutoLayout: true)
                nestedStackView.addArrangedSubview(emptyView)
            }
            return nestedStackView
        }

        stackView.spacing = stackViewSpacing
        stackView.addArrangedSubviews(nestedStackViews)
    }
}
