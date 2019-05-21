//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

final class PhaseView: UIView {
    private enum DotSize: Float {
        case regular = 12
        case highlighted = 20

        var value: CGFloat { return CGFloat(rawValue) }
    }

    static var dotCenterX: CGFloat {
        return DotSize.highlighted.value / 2
    }

    private lazy var titleLabel: UILabel = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .licorice
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private lazy var detailTextLabel: UILabel = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .licorice
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return label
    }()

    private(set) lazy var dotView = UIView(withAutoLayout: true)
    private lazy var dotViewWidthConstraint = self.dotView.widthAnchor.constraint(equalToConstant: 0)

    override var intrinsicContentSize: CGSize {
        return CGSize(width: frame.width, height: DotSize.highlighted.value)
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

        dotView.backgroundColor = viewModel.isHighlighted ? .milk : .sardine
        dotView.layer.borderColor = viewModel.isHighlighted ? .secondaryBlue : nil
        dotView.layer.borderWidth = viewModel.isHighlighted ? 2 : 0

        let dotWidth: DotSize = viewModel.isHighlighted ? .highlighted : .regular
        dotView.layer.cornerRadius = CGFloat(dotWidth.value) / 2
        dotViewWidthConstraint.constant = dotWidth.value

        layoutIfNeeded()
    }

    private func setup() {
        addSubview(dotView)
        addSubview(titleLabel)
        addSubview(detailTextLabel)

        let titleLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(
            equalTo: leadingAnchor,
            constant: PhaseView.dotCenterX * 2 + .mediumSpacing
        )

        titleLabelLeadingConstraint.priority = UILayoutPriority.init(rawValue: 999)

        NSLayoutConstraint.activate([
            dotView.centerYAnchor.constraint(equalTo: centerYAnchor),
            dotView.centerXAnchor.constraint(equalTo: leadingAnchor, constant: PhaseView.dotCenterX),
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
