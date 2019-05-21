//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

final class PhaseView: UIView {
    private static let regularDotSize: CGFloat = 12
    private static let highlightedDotSize: CGFloat = 20

    // MARK: - Internal properties

    private(set) lazy var dotView = UIView(withAutoLayout: true)

    // MARK: - Private properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .bodyStrong
        label.textColor = .licorice
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private lazy var detailTextLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .detail
        label.textColor = .licorice
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var dotViewWidthConstraint = self.dotView.widthAnchor.constraint(equalToConstant: 0)

    // MARK: - Overrides

    override var intrinsicContentSize: CGSize {
        return CGSize(width: frame.width, height: PhaseView.highlightedDotSize)
    }

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

    func configure(with viewModel: PhaseViewModel) {
        titleLabel.text = viewModel.title
        detailTextLabel.text = " - \(viewModel.detailText)"

        titleLabel.font = viewModel.isHighlighted ? .bodyStrong : .detailStrong

        dotView.backgroundColor = viewModel.isHighlighted ? .milk : .sardine
        dotView.layer.borderColor = viewModel.isHighlighted ? .secondaryBlue : nil
        dotView.layer.borderWidth = viewModel.isHighlighted ? 3 : 0

        let dotWidth = viewModel.isHighlighted ? PhaseView.highlightedDotSize : PhaseView.regularDotSize
        dotView.layer.cornerRadius = dotWidth / 2
        dotViewWidthConstraint.constant = dotWidth

        layoutIfNeeded()
    }

    private func setup() {
        addSubview(dotView)
        addSubview(titleLabel)
        addSubview(detailTextLabel)

        let dotWidth = PhaseView.highlightedDotSize
        let titleLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: dotWidth + .mediumSpacing
        )

        titleLabelLeadingConstraint.priority = UILayoutPriority(rawValue: 999)

        NSLayoutConstraint.activate([
            dotView.centerYAnchor.constraint(equalTo: centerYAnchor),
            dotView.centerXAnchor.constraint(equalTo: leadingAnchor, constant: dotWidth / 2),
            dotView.heightAnchor.constraint(equalTo: dotView.widthAnchor),
            dotViewWidthConstraint,

            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabelLeadingConstraint,

            detailTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            detailTextLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            detailTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
