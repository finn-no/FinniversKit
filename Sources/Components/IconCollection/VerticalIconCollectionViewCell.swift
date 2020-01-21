//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class VerticalIconCollectionViewCell: UICollectionViewCell {
    private static let textSideMargin = CGFloat.mediumSpacing

    static func height(for viewModel: IconCollectionViewModel, withWidth width: CGFloat) -> CGFloat {
        let textRect = viewModel.text.boundingRect(
            with: CGSize(width: width - (2 * textSideMargin), height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.body],
            context: nil
        )

        let imageHeight = viewModel.image.size.height

        return textRect.height + imageHeight + .mediumSpacing
    }

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var textLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .body
        label.textColor = .textPrimary
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
        textLabel.text = ""
        accessibilityLabel = ""
    }

    // MARK: - Setup

    func configure(with viewModel: IconCollectionViewModel) {
        iconImageView.image = viewModel.image
        textLabel.text = viewModel.text
        accessibilityLabel = viewModel.text
    }

    private func setup() {
        isAccessibilityElement = true

        addSubview(iconImageView)
        addSubview(textLabel)

        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: topAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),

            textLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: .smallSpacing),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: VerticalIconCollectionViewCell.textSideMargin),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -VerticalIconCollectionViewCell.textSideMargin)
        ])
    }
}
