//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol FavoriteAdTableViewCellDelegate: AnyObject {
    func favoriteAdTableViewCellDidSelectMoreButton(_ cell: FavoriteAdTableViewCell)
}

public class FavoriteAdTableViewCell: UITableViewCell {

    // MARK: - Public properties

    public weak var delegate: FavoriteAdTableViewCellDelegate?

    public weak var remoteImageViewDataSource: RemoteImageViewDataSource? {
        didSet {
            remoteImageView.dataSource = remoteImageViewDataSource
        }
    }

    public var loadingColor: UIColor?

    // MARK: - Private properties

    private lazy var addressLabel = label(withFont: .detail, textColor: .stone, numberOfLines: 2)
    private lazy var titleLabel = label(withFont: .caption, textColor: .licorice, numberOfLines: 2)
    private lazy var descriptionPrimaryLabel = label(withFont: .bodyStrong, textColor: .licorice, numberOfLines: 0)
    private lazy var descriptionSecondaryLabel = label(withFont: .detailStrong, textColor: .licorice, numberOfLines: 0)

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

    private lazy var moreButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        let image = UIImage(named: .more).withRenderingMode(.alwaysTemplate)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .stone
        button.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(vertical: 10, horizontal: 8)
        return button
    }()

    private let statusRibbon = RibbonView(withAutoLayout: true)

    private var viewModel: FavoriteAdViewModel?
    private let fallbackImage: UIImage = UIImage(named: .noImage)
    private let adImageWidth: CGFloat = 80

    // MARK: - Init

    public override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()

        remoteImageView.cancelLoading()
        remoteImageView.setImage(nil, animated: false)
        [addressLabel, titleLabel, descriptionPrimaryLabel, descriptionSecondaryLabel].forEach {
            $0.text = nil
            $0.isHidden = true
        }
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        let ribbonBackgroundColor = statusRibbon.backgroundColor
        let remoteImageViewBackgroundColor = remoteImageView.backgroundColor
        super.setSelected(selected, animated: animated)
        statusRibbon.backgroundColor = ribbonBackgroundColor
        remoteImageView.backgroundColor = remoteImageView.image == nil ? remoteImageViewBackgroundColor : .clear
    }

    public override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let ribbonBackgroundColor = statusRibbon.backgroundColor
        let remoteImageViewBackgroundColor = remoteImageView.backgroundColor
        super.setHighlighted(highlighted, animated: animated)
        statusRibbon.backgroundColor = ribbonBackgroundColor
        remoteImageView.backgroundColor = remoteImageView.image == nil ? remoteImageViewBackgroundColor : .clear
    }

    // MARK: - Setup

    private func setup() {
        setDefaultSelectedBackgound()

        stackView.addArrangedSubview(addressLabel)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionPrimaryLabel)
        stackView.addArrangedSubview(descriptionSecondaryLabel)

        stackView.setCustomSpacing(.mediumSpacing, after: titleLabel)

        contentView.addSubview(remoteImageView)
        contentView.addSubview(statusRibbon)
        contentView.addSubview(moreButton)
        contentView.addSubview(stackView)

        NSLayoutConstraint.activate([
            remoteImageView.heightAnchor.constraint(equalToConstant: adImageWidth),
            remoteImageView.widthAnchor.constraint(equalToConstant: adImageWidth),
            remoteImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            remoteImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),

            statusRibbon.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumSpacing),
            statusRibbon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumSpacing),

            moreButton.widthAnchor.constraint(equalToConstant: 40),
            moreButton.heightAnchor.constraint(equalToConstant: 44),
            moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            moreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            stackView.leadingAnchor.constraint(equalTo: remoteImageView.trailingAnchor, constant: .mediumLargeSpacing),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: moreButton.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24),

            addressLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusRibbon.leadingAnchor, constant: -.mediumSpacing)
        ])
    }

    // MARK: - Public methods

    public func configure(with viewModel: FavoriteAdViewModel) {
        separatorInset = .leadingInset(.mediumLargeSpacing * 2 + adImageWidth)

        self.viewModel = viewModel

        statusRibbon.style = viewModel.ribbonStyle
        statusRibbon.title = viewModel.ribbonTitle

        if let addressText = viewModel.addressText {
            addressLabel.text = addressText
            addressLabel.isHidden = false
        }

        titleLabel.text = viewModel.titleText
        titleLabel.isHidden = false

        if let descriptionPrimaryText = viewModel.descriptionPrimaryText {
            descriptionPrimaryLabel.text = descriptionPrimaryText
            descriptionPrimaryLabel.isHidden = false
        }

        if let descriptionSecondaryText = viewModel.descriptionSecondaryText {
            descriptionSecondaryLabel.text = descriptionSecondaryText
            descriptionSecondaryLabel.isHidden = false
        }
    }

    public func loadImage() {
        guard let viewModel = viewModel, let imagePath = viewModel.imagePath else {
            remoteImageView.setImage(fallbackImage, animated: false)
            return
        }

        remoteImageView.loadImage(for: imagePath, imageWidth: adImageWidth, loadingColor: loadingColor, fallbackImage: fallbackImage)
    }

    // MARK: - Private methods

    @objc private func moreButtonTapped() {
        delegate?.favoriteAdTableViewCellDidSelectMoreButton(self)
    }

    private func label(withFont font: UIFont, textColor: UIColor, numberOfLines: Int) -> UILabel {
        let label = UILabel(withAutoLayout: true)
        label.font = font
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        return label
    }
}
