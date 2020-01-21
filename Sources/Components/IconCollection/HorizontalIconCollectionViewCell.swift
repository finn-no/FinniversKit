//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class HorizontalIconCollectionViewCell: UICollectionViewCell {
    private static let titleSideMargin = CGFloat.mediumSpacing

    static func height(for viewModel: IconCollectionViewModel, withWidth width: CGFloat) -> CGFloat {
        let imageSize = viewModel.image.size
        let textWidth = width - imageSize.width - (2 * titleSideMargin)

        let textRect = viewModel.text.boundingRect(
            with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.body],
            context: nil
        )

        guard let title = viewModel.title else {
            return max(imageSize.height, textRect.height)
        }

        let titleRect = title.boundingRect(
            with: CGSize(width: textWidth, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: UIFont.bodyStrong],
            context: nil
        )

        let textHeight = titleRect.height + textRect.height + .smallSpacing

        return max(imageSize.height, textHeight)
    }

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .body
        label.textColor = .textPrimary
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()

    private lazy var bodyLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .bodyStrong
        label.textColor = .textPrimary
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()

    private lazy var textWrappingView = UIView(withAutoLayout: true)

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
        bodyLabel.text = ""
        accessibilityLabel = ""
    }

    // MARK: - Setup

    func configure(with viewModel: IconCollectionViewModel) {
        iconImageView.image = viewModel.image
        titleLabel.text = viewModel.title
        bodyLabel.text = viewModel.text
        accessibilityLabel = "\(viewModel.title): \(viewModel.text)"
    }

    private func setup() {
        isAccessibilityElement = true

        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(bodyLabel)

        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: HorizontalIconCollectionViewCell.titleSideMargin),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .smallSpacing),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: HorizontalIconCollectionViewCell.titleSideMargin),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -HorizontalIconCollectionViewCell.titleSideMargin),

            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            bodyLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: HorizontalIconCollectionViewCell.titleSideMargin),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -HorizontalIconCollectionViewCell.titleSideMargin)
        ])
    }
}
