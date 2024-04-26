//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class HorizontalIconCollectionViewCell: UICollectionViewCell {
    private static let titleSideMargin = CGFloat.spacingS
    private static let titleStyle = Label.Style.body
    private static let bodyStyle = Label.Style.bodyStrong

    static func height(for viewModel: IconCollectionViewModel, withWidth width: CGFloat) -> CGFloat {
        let imageSize = viewModel.image.size
        let textWidth = width - imageSize.width - (3 * titleSideMargin)

        let titleHeight = viewModel.title?.height(withConstrainedWidth: textWidth, font: titleStyle.font) ?? 0
        let bodyHeight = viewModel.text.height(withConstrainedWidth: textWidth, font: bodyStyle.font)

        let textHeight = titleHeight + bodyHeight + .spacingXS

        return max(imageSize.height, textHeight)
    }

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
        imageView.setContentHuggingPriority(.required, for: .horizontal)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = Label(style: Self.titleStyle, withAutoLayout: true)
        label.numberOfLines = 0
        return label
    }()

    private lazy var bodyLabel: UILabel = {
        let label = Label(style: Self.bodyStyle, withAutoLayout: true)
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
        bodyLabel.text = ""
        accessibilityLabel = ""
    }

    // MARK: - Setup

    func configure(with viewModel: IconCollectionViewModel) {
        iconImageView.image = viewModel.image
        titleLabel.text = viewModel.title
        bodyLabel.text = viewModel.text

        if let title = viewModel.title {
            accessibilityLabel = "\(title): \(viewModel.text)"
        } else {
            accessibilityLabel = "\(viewModel.text)"
        }
    }

    private func setup() {
        isAccessibilityElement = true

        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyLabel)

        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: HorizontalIconCollectionViewCell.titleSideMargin),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingXS),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: HorizontalIconCollectionViewCell.titleSideMargin),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -HorizontalIconCollectionViewCell.titleSideMargin),

            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            bodyLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: HorizontalIconCollectionViewCell.titleSideMargin),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -HorizontalIconCollectionViewCell.titleSideMargin)
        ])
    }
}
