//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class IconCollectionViewCell: UICollectionViewCell {
    private static let titleSideMargin = CGFloat.mediumSpacing

    static func height(for viewModel: IconCollectionViewModel, withWidth width: CGFloat) -> CGFloat {
        let titleRect = viewModel.title.boundingRect(
            with: CGSize(width: width - (2 * titleSideMargin), height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.body],
            context: nil
        )

        let titleHeight = titleRect.height
        let imageHeight = viewModel.image.size.height

        return titleHeight + imageHeight + .mediumSpacing
    }

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .body
        label.textColor = .licorice
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        titleLabel.text = ""
        accessibilityLabel = ""
    }

    // MARK: - Setup

    func configure(with viewModel: IconCollectionViewModel) {
        iconImageView.image = viewModel.image
        titleLabel.text = viewModel.title
        accessibilityLabel = viewModel.title
    }

    private func setup() {
        backgroundColor = .bgPrimary
        isAccessibilityElement = true

        addSubview(iconImageView)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),

            titleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: .smallSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: IconCollectionViewCell.titleSideMargin),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -IconCollectionViewCell.titleSideMargin)
        ])
    }
}
