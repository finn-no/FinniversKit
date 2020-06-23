//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class IconLinkListView: UIView {

    // MARK: - Private properties

    private weak var delegate: IconLinkViewDelegate?
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = .spacingM
        return stackView
    }()

    // MARK: - Init

    public init(delegate: IconLinkViewDelegate, withAutoLayout: Bool = false) {
        self.delegate = delegate
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

    public func configure(with viewModels: [IconLinkViewModel]) {
        stackView.removeArrangedSubviews()

        let chunked = viewModels.chunked(by: 2)
        let nestedStackViews = chunked.map { models -> UIStackView in
            let nestedStackView = UIStackView(withAutoLayout: true)
            nestedStackView.axis = .horizontal
            nestedStackView.distribution = .fillEqually
            nestedStackView.spacing = .spacingM

            let views = models.map { IconLinkView.create(from: $0, delegate: delegate) }
            nestedStackView.addArrangedSubviews(views)

            if views.count == 1 && viewModels.count > 1 {
                let emptyView = UIView(withAutoLayout: true)
                nestedStackView.addArrangedSubview(emptyView)
            }

            return nestedStackView
        }

        stackView.addArrangedSubviews(nestedStackViews)
    }
}

// MARK: - Private extension

private extension IconLinkView {
    static func create(from viewModel: IconLinkViewModel, delegate: IconLinkViewDelegate?) -> IconLinkView {
        let view = IconLinkView(withAutoLayout: true)
        view.delegate = delegate
        view.configure(with: viewModel)
        return view
    }
}
