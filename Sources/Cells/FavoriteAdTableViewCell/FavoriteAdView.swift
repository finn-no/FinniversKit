//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

final class FavoriteAdView: UIView {
    static let adImageWidth: CGFloat = 80

    weak var remoteImageViewDataSource: RemoteImageViewDataSource? {
        didSet {
            remoteImageView.dataSource = remoteImageViewDataSource
        }
    }

    var loadingColor: UIColor?

    // MARK: - Private properties

    private var viewModel: FavoriteAdViewModel?

    private lazy var addressLabel = label(withFont: .detail, textColor: .stone, numberOfLines: 2)
    private lazy var titleLabel = label(withFont: .caption, textColor: .licorice, numberOfLines: 2, isHidden: false)
    private lazy var descriptionPrimaryLabel = label(withFont: .bodyStrong, textColor: .licorice, numberOfLines: 0)
    private lazy var descriptionSecondaryLabel = label(withFont: .detail, textColor: .licorice, numberOfLines: 0)
    private lazy var statusRibbon = RibbonView(withAutoLayout: true)
    private lazy var fallbackImage: UIImage = UIImage(named: .noImage)

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var remoteImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var stackViewBottomConstraint: NSLayoutConstraint = {
        let constraint = stackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -24)
        constraint.priority = .defaultLow
        return constraint
    }()

    private lazy var remoteImageViewBottomConstraint: NSLayoutConstraint = {
        let constraint = remoteImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -24)
        constraint.priority = .defaultLow
        return constraint
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Internal

    func configure(with viewModel: FavoriteAdViewModel) {
        self.viewModel = viewModel

        statusRibbon.style = viewModel.ribbonStyle
        statusRibbon.title = viewModel.ribbonTitle

        if let addressText = viewModel.addressText {
            addressLabel.text = addressText
            addressLabel.isHidden = false
        }

        titleLabel.text = viewModel.titleText
        titleLabel.textColor = viewModel.titleColor

        if let descriptionPrimaryText = viewModel.descriptionPrimaryText {
            descriptionPrimaryLabel.text = descriptionPrimaryText
            descriptionPrimaryLabel.isHidden = false
        }

        if let descriptionSecondaryText = viewModel.descriptionSecondaryText {
            descriptionSecondaryLabel.text = descriptionSecondaryText
            descriptionSecondaryLabel.isHidden = false
        }
    }

    func loadImage() {
        guard let viewModel = viewModel, let imagePath = viewModel.imagePath else {
            remoteImageView.setImage(fallbackImage, animated: false)
            return
        }

        remoteImageView.loadImage(
            for: imagePath,
            imageWidth: FavoriteAdView.adImageWidth,
            loadingColor: loadingColor,
            fallbackImage: fallbackImage
        )
    }

    func resetContent() {
        remoteImageView.cancelLoading()
        remoteImageView.setImage(nil, animated: false)

        [addressLabel, descriptionPrimaryLabel, descriptionSecondaryLabel].forEach {
            $0.text = nil
            $0.isHidden = true
        }
    }

    func resetBackgroundColors() {
        let ribbonBackgroundColor = statusRibbon.backgroundColor
        let remoteImageViewBackgroundColor = remoteImageView.backgroundColor

        statusRibbon.backgroundColor = ribbonBackgroundColor
        remoteImageView.backgroundColor = remoteImageView.image == nil ? remoteImageViewBackgroundColor : .clear
    }

    // MARK: - Setup

    private func setup() {
        stackView.addArrangedSubview(addressLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionPrimaryLabel)
        stackView.addArrangedSubview(descriptionSecondaryLabel)

        stackView.setCustomSpacing(.verySmallSpacing, after: addressLabel)
        stackView.setCustomSpacing(.mediumSpacing, after: titleLabel)
        stackView.setCustomSpacing(.smallSpacing, after: descriptionPrimaryLabel)

        addSubview(remoteImageView)
        addSubview(statusRibbon)
        addSubview(stackView)

        NSLayoutConstraint.activate([
            remoteImageView.widthAnchor.constraint(equalToConstant: FavoriteAdView.adImageWidth),
            remoteImageView.heightAnchor.constraint(equalTo: remoteImageView.widthAnchor),
            remoteImageView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            remoteImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            remoteImageViewBottomConstraint,

            statusRibbon.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            statusRibbon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),

            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: remoteImageView.trailingAnchor, constant: .mediumLargeSpacing),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -.mediumLargeSpacing),
            stackViewBottomConstraint,

            addressLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusRibbon.leadingAnchor, constant: -.mediumSpacing)
        ])
    }

    // MARK: - Private methods

    private func label(withFont font: UIFont, textColor: UIColor, numberOfLines: Int, isHidden: Bool = true) -> UILabel {
        let label = UILabel(withAutoLayout: true)
        label.font = font
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        label.isHidden = isHidden
        return label
    }
}
