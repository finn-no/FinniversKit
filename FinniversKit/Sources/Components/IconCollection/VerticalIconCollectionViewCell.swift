//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class VerticalIconCollectionViewCell: UICollectionViewCell {
    private static let textSideMargin = CGFloat.spacingS
    private static let bodyStyle = Label.Style.body

    static func height(for viewModel: IconCollectionViewModel, withWidth width: CGFloat) -> CGFloat {
        let textWidth = width - (2 * textSideMargin)
        let textHeight = viewModel.text.height(withConstrainedWidth: textWidth, font: bodyStyle.font)

        let imageHeight = viewModel.image.size.height

        return textHeight + imageHeight + .spacingS
    }

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        imageView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var textLabel: UILabel = {
        let label = Label(style: Self.bodyStyle, withAutoLayout: true)
        label.textAlignment = .center
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

        contentView.addSubview(iconImageView)
        contentView.addSubview(textLabel)

        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            textLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: .spacingXS),
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: VerticalIconCollectionViewCell.textSideMargin),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -VerticalIconCollectionViewCell.textSideMargin)
        ])
    }
}
