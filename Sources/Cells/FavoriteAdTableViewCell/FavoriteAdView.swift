//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

protocol FavoriteAdViewDelegate: AnyObject {
    func favoriteAdView(_ view: FavoriteAdView, didSelectMoreButton button: UIButton)
}

final class FavoriteAdView: UIView {
    static let adImageWidth: CGFloat = 80
    static let verticalPadding: CGFloat = 24

    weak var delegate: FavoriteAdViewDelegate?
    weak var remoteImageViewDataSource: RemoteImageViewDataSource? {
        didSet {
            remoteImageView.dataSource = remoteImageViewDataSource
        }
    }

    var loadingColor: UIColor?

    var isMoreButtonHidden: Bool {
        get { return moreButton.isHidden }
        set { moreButton.isHidden = newValue }
    }

    var isCommentViewHidden = false {
        didSet {
            configureCommentView()
        }
    }

    // MARK: - Private properties

    private var viewModel: FavoriteAdViewModel?

    private lazy var sortingDetailLabel = label(withFont: .detailStrong, textColor: .textAction, numberOfLines: 2)
    private lazy var addressLabel = label(withFont: .detail, textColor: .textSecondary, numberOfLines: 2, isHidden: false)
    private lazy var titleLabel = label(withFont: .caption, textColor: .textPrimary, numberOfLines: 2, isHidden: false)
    private lazy var descriptionPrimaryLabel = label(withFont: .bodyStrong, textColor: .textPrimary, numberOfLines: 0)
    private lazy var descriptionSecondaryLabel = label(withFont: .detail, textColor: .textPrimary, numberOfLines: 0)
    private lazy var descriptionTertiaryLabel = label(withFont: .detailStrong, textColor: .textPrimary, numberOfLines: 0)
    private lazy var statusRibbon = RibbonView(withAutoLayout: true)
    private lazy var commentView = FavoriteAdCommentView(withAutoLayout: true)
    private lazy var fallbackImage: UIImage = UIImage(named: .noImage)

    private lazy var rootStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = .spacingM
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .horizontal
        stackView.spacing = .spacingM
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var textStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var contentView = UIView(withAutoLayout: true)

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

    // MARK: - Overrides

    override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: rootStackView.frame.maxY + FavoriteAdView.verticalPadding)
    }

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Internal

    func configure(with viewModel: FavoriteAdViewModel) {
        self.viewModel = viewModel

        configureCommentView()

        statusRibbon.configure(with: viewModel.ribbonViewModel)

        addressLabel.text = viewModel.addressText ?? " "

        titleLabel.text = viewModel.titleText
        titleLabel.textColor = viewModel.titleColor

        if let sortingDetailText = viewModel.sortingDetailText {
            sortingDetailLabel.text = sortingDetailText
            sortingDetailLabel.isHidden = false
        }

        if let descriptionPrimaryText = viewModel.descriptionPrimaryText {
            descriptionPrimaryLabel.text = descriptionPrimaryText
            descriptionPrimaryLabel.isHidden = false
        }

        if let descriptionSecondaryText = viewModel.descriptionSecondaryText {
            descriptionSecondaryLabel.text = descriptionSecondaryText
            descriptionSecondaryLabel.isHidden = false
        }

        if let descriptionTertiaryText = viewModel.descriptionTertiaryText {
            descriptionTertiaryLabel.text = descriptionTertiaryText
            descriptionTertiaryLabel.isHidden = false
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

        addressLabel.text = nil
        [sortingDetailLabel, descriptionPrimaryLabel, descriptionSecondaryLabel, descriptionTertiaryLabel].forEach {
            $0.text = nil
            $0.isHidden = true
        }

        commentView.configure(withText: nil)
        commentView.isHidden = true
    }

    func resetBackgroundColors() {
        remoteImageView.backgroundColor = remoteImageView.image == nil ? loadingColor : .clear
        commentView.backgroundColor = FavoriteAdCommentView.defaultBackgroundColor

        if let ribbonViewModel = viewModel?.ribbonViewModel {
            statusRibbon.style = ribbonViewModel.style
        }
    }

    // MARK: - Setup

    private func setup() {
        infoStackView.addArrangedSubview(remoteImageView)
        infoStackView.addArrangedSubview(textStackView)

        textStackView.addArrangedSubview(sortingDetailLabel)
        textStackView.addArrangedSubview(addressLabel)
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(descriptionPrimaryLabel)
        textStackView.addArrangedSubview(descriptionSecondaryLabel)
        textStackView.addArrangedSubview(descriptionTertiaryLabel)

        textStackView.setCustomSpacing(.spacingXXS, after: sortingDetailLabel)
        textStackView.setCustomSpacing(.spacingXXS, after: addressLabel)
        textStackView.setCustomSpacing(.spacingS, after: titleLabel)
        textStackView.setCustomSpacing(.spacingXS, after: descriptionPrimaryLabel)
        textStackView.setCustomSpacing(.spacingS, after: descriptionSecondaryLabel)

        contentView.addSubview(infoStackView)
        contentView.addSubview(statusRibbon)
        contentView.addSubview(moreButton)

        rootStackView.addArrangedSubview(contentView)
        rootStackView.addArrangedSubview(commentView)

        addSubview(rootStackView)

        let padding = FavoriteAdView.verticalPadding
        let rootStackViewBottomConstraint = rootStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        rootStackViewBottomConstraint.priority = UILayoutPriority(rawValue: 999)

        NSLayoutConstraint.activate([
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor),

            rootStackView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            rootStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            rootStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            rootStackViewBottomConstraint,

            infoStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            infoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoStackView.trailingAnchor.constraint(equalTo: moreButton.leadingAnchor),
            infoStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            moreButton.widthAnchor.constraint(equalToConstant: 40),
            moreButton.heightAnchor.constraint(equalToConstant: 44),
            moreButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            moreButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            remoteImageView.widthAnchor.constraint(equalToConstant: FavoriteAdView.adImageWidth),
            remoteImageView.heightAnchor.constraint(equalTo: remoteImageView.widthAnchor),

            statusRibbon.topAnchor.constraint(equalTo: topAnchor, constant: .spacingS),
            statusRibbon.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),

            sortingDetailLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusRibbon.leadingAnchor, constant: -.spacingS),
            addressLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusRibbon.leadingAnchor, constant: -.spacingS),

            commentView.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor, constant: -.spacingM)
        ])
    }

    // MARK: - Private methods

    @objc private func moreButtonTapped() {
        delegate?.favoriteAdView(self, didSelectMoreButton: moreButton)
    }

    private func configureCommentView() {
        if let comment = viewModel?.comment, !comment.isEmpty, !isCommentViewHidden {
            commentView.configure(withText: comment)
            commentView.isHidden = false
        } else {
            commentView.isHidden = true
        }
    }

    private func label(withFont font: UIFont, textColor: UIColor, numberOfLines: Int, isHidden: Bool = true) -> UILabel {
        let label = UILabel(withAutoLayout: true)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.font = font
        label.textColor = textColor
        label.numberOfLines = numberOfLines
        label.isHidden = isHidden
        return label
    }
}
