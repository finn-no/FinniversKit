//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol PriceLinkButtonListViewDelegate: AnyObject {
    func priceLinksListView(_ view: PriceLinkButtonListView, didTapButtonWithIdentifier identifier: String?, url: URL)
}

public class PriceLinkButtonListView: UIView {

    // MARK: - Public properties

    public weak var delegate: PriceLinkButtonListViewDelegate?

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

    public func configure(with viewModels: [PriceLinkButtonViewModel]) {
        stackView.removeArrangedSubviews()
        viewModels.map(PriceLinkButtonView.init(viewModel:)).forEach {
            $0.setContentHuggingPriority(.required, for: .horizontal)
            $0.delegate = self
            stackView.addArrangedSubview($0)
        }
    }
}

// MARK: - PriceLinkButtonViewDelegate

extension PriceLinkButtonListView: PriceLinkButtonViewDelegate {
    func priceLinkButton(withIdentifier identifier: String?, wasTappedWithUrl url: URL) {
        delegate?.priceLinksListView(self, didTapButtonWithIdentifier: identifier, url: url)
    }
}
