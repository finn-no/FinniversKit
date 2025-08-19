//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

public class HorizontalIconCollectionViewCell: UICollectionViewCell {
    private static let leadingInset: CGFloat = 0
    private static let trailingInset: CGFloat = Warp.Spacing.spacing100
    private static let iconToTextSpacing: CGFloat = Warp.Spacing.spacing100
    private static let verticalPadding: CGFloat = Warp.Spacing.spacing50
    private static let titleStyle = Warp.Typography.body
    private static let bodyStyle = Warp.Typography.bodyStrong

    static func height(for viewModel: IconCollectionViewModel, withWidth width: CGFloat) -> CGFloat {
        let imageSize = viewModel.image.size
        let textWidth = width
                    - imageSize.width
                    - (Self.leadingInset + Self.iconToTextSpacing + Self.trailingInset)

        let titleHeight = viewModel.title?.height(withConstrainedWidth: textWidth, font: titleStyle.uiFont) ?? 0
        let bodyHeight = viewModel.text.height(withConstrainedWidth: textWidth, font: bodyStyle.uiFont)

        let textHeight = titleHeight + bodyHeight + Warp.Spacing.spacing50

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
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Self.leadingInset),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Self.verticalPadding),
            titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Self.iconToTextSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Self.trailingInset),

            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            bodyLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Self.iconToTextSpacing),
            bodyLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Self.trailingInset),

            bodyLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -Self.verticalPadding)
        ])
    }
}
