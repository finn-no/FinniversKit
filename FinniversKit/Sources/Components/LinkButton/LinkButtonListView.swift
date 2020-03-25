//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol LinkButtonListViewDelegate: AnyObject {
    func linksListView(_ view: LinkButtonListView, didTapButtonWithIdentifier identifier: String?, url: URL)
}

public class LinkButtonListView: UIView {

    // MARK: - Public properties

    public weak var delegate: LinkButtonListViewDelegate?

    // MARK: - Private properties

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = .spacingS
        return stackView
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(stackView)
        stackView.fillInSuperview()
    }

    // MARK: - Public methods

    public func configure(with viewModels: [LinkButtonViewModel]) {
        stackView.removeArrangedSubviews()
        viewModels.map(LinkButtonView.init(viewModel:)).forEach {
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.delegate = self
            stackView.addArrangedSubview($0)
        }
    }
}

// MARK: - LinkButtonViewDelegate

extension LinkButtonListView: LinkButtonViewDelegate {
    func linkButton(withIdentifier identifier: String?, wasTappedWithUrl url: URL) {
        delegate?.linksListView(self, didTapButtonWithIdentifier: identifier, url: url)
    }
}
