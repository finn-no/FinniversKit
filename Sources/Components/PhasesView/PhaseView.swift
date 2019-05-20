//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

final class PhaseView: UIView {
    private lazy var titleLabel: UILabel = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .licorice
        return label
    }()

    private lazy var detailTextLabel: UILabel = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .licorice
        return label
    }()

    private(set) lazy var dotView = UIView(withAutoLayout: true)
    private lazy var dotViewWidthConstraint = self.dotView.widthAnchor.constraint(equalToConstant: 0)

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    public func configure(with viewModel: PhaseViewModel) {
        titleLabel.text = viewModel.title
        detailTextLabel.text = " - \(viewModel.detailText)"

        dotView.backgroundColor = viewModel.isHighlighted ? .milk : .stone
        dotView.layer.borderColor = viewModel.isHighlighted ? .secondaryBlue : nil
        dotView.layer.borderWidth = viewModel.isHighlighted ? 2 : 0

        let dotWidth: CGFloat = viewModel.isHighlighted ? 20 : 12
        dotView.layer.cornerRadius = dotWidth / 2
        dotViewWidthConstraint.constant = dotWidth

        layoutIfNeeded()
    }

    private func setup() {
        addSubview(dotView)
        addSubview(titleLabel)
        addSubview(detailTextLabel)

        NSLayoutConstraint.activate([
            dotView.topAnchor.constraint(equalTo: topAnchor),
            dotView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dotView.heightAnchor.constraint(equalTo: dotView.widthAnchor),
            dotViewWidthConstraint,

            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: dotView.trailingAnchor, constant: .mediumSpacing),

            detailTextLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            detailTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
