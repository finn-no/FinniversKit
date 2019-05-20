//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

final class PhaseView: UIView {
    private enum DotWidth: Float {
        case regular = 12
        case highlighted = 20

        var value: CGFloat { return CGFloat(rawValue) }
    }

    static var dotCenterX: CGFloat {
        return DotWidth.highlighted.value
    }

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

        let dotWidth: DotWidth = viewModel.isHighlighted ? .highlighted : .regular
        dotView.layer.cornerRadius = CGFloat(dotWidth.value) / 2
        dotViewWidthConstraint.constant = dotWidth.value

        layoutIfNeeded()
    }

    private func setup() {
        addSubview(dotView)
        addSubview(titleLabel)
        addSubview(detailTextLabel)

        NSLayoutConstraint.activate([
            dotView.topAnchor.constraint(equalTo: topAnchor),
            dotView.centerXAnchor.constraint(equalTo: leadingAnchor, constant: PhaseView.dotCenterX),
            dotView.heightAnchor.constraint(equalTo: dotView.widthAnchor),
            dotViewWidthConstraint,

            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: dotView.trailingAnchor, constant: .mediumSpacing),

            detailTextLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            detailTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
