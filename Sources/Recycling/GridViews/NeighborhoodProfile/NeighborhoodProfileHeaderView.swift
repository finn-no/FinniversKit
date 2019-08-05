//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

protocol NeighborhoodProfileHeaderViewDelegate: AnyObject {
    func neighborhoodProfileHeaderViewDidSelectButton(_ view: NeighborhoodProfileHeaderView)
}

final class NeighborhoodProfileHeaderView: UIView {
    weak var delegate: NeighborhoodProfileHeaderViewDelegate?

    var title = "" {
        didSet {
            titleLabel.text = title
        }
    }

    var buttonTitle = "" {
        didSet {
            button.setTitle(buttonTitle, for: .normal)
        }
    }

    // MARK: - Private properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .title3
        label.textColor = .licorice
        return label
    }()

    private lazy var button: UIButton = {
        let button = Button(style: .link)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(titleLabel)
        addSubview(button)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),

            button.leadingAnchor.constraint(greaterThanOrEqualTo: titleLabel.trailingAnchor, constant: .mediumLargeSpacing),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor)
        ])
    }

    // MARK: - Actions

    @objc private func handleButtonTap() {
        delegate?.neighborhoodProfileHeaderViewDidSelectButton(self)
    }
}
