//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI
import UIKit
import Warp

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

    private lazy var sortingDetailLabel = label(style: .detailStrong, textColor: Warp.UIToken.textSubtle, numberOfLines: 2)

    private lazy var addressLabel = label(style: .detail, textColor: .textSubtle, numberOfLines: 2, isHidden: false)
    private lazy var titleLabel = label(style: .caption, textColor: .text, numberOfLines: 2, isHidden: false)
    private lazy var descriptionPrimaryLabel = label(style: .bodyStrong, textColor: .text, numberOfLines: 0)
    private lazy var descriptionSecondaryLabel = label(style: .detail, textColor: .text, numberOfLines: 0)
    private lazy var descriptionTertiaryLabel = label(style: .detailStrong, textColor: .text, numberOfLines: 0)
    private lazy var statusBadgeHostingController: UIHostingController<StatusBadgeView> = {
        let host = UIHostingController(rootView: StatusBadgeView(text: "", variant: .neutral))
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.backgroundColor = .clear
        host.view.isAccessibilityElement = true
        if #available(iOS 16, *) {
            host.sizingOptions = .intrinsicContentSize
        }
        return host
    }()
    private var statusBadgeView: UIView { statusBadgeHostingController.view }
    private lazy var commentHostingController: UIHostingController<CommentAlertView> = {
        let host = UIHostingController(rootView: CommentAlertView(title: "", text: ""))
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.backgroundColor = .clear
        host.view.isAccessibilityElement = true
        if #available(iOS 16, *) {
            host.sizingOptions = .intrinsicContentSize
        }
        return host
    }()
    private var commentView: UIView { commentHostingController.view }
    private lazy var fallbackImage: UIImage = UIImage(named: .noImage)

    private lazy var rootStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = Warp.Spacing.spacing200
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var infoStackView = DynamicStackView(
        breakAtContentSize: .extraExtraLarge,
        spacing: .individual(
            horizontal: Warp.Spacing.spacing200,
            vertical: Warp.Spacing.spacing100
        ),
        alignment: .both(.leading),
        distribution: .both(.fill),
        delegate: nil,
        withAutoLayout: true
    )

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
        button.tintColor = Warp.UIToken.icon
        button.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(vertical: 10, horizontal: 8)
        return button
    }()

    // MARK: - Overrides

    override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: rootStackView.bounds.maxY + FavoriteAdView.verticalPadding)
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

        if let ribbonViewModel = viewModel.ribbonViewModel {
            updateStatusBadge(from: ribbonViewModel)
            statusBadgeView.isHidden = false
        } else {
            statusBadgeView.isHidden = true
        }

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

        updateCommentAlert(title: "", text: "")
        commentView.accessibilityLabel = nil
        commentView.isHidden = true
    }

    func resetBackgroundColors() {
        remoteImageView.backgroundColor = remoteImageView.image == nil ? loadingColor : .clear
        commentView.backgroundColor = .clear

        if let ribbonViewModel = viewModel?.ribbonViewModel {
            updateStatusBadge(from: ribbonViewModel)
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

        textStackView.setCustomSpacing(Warp.Spacing.spacing25, after: sortingDetailLabel)
        textStackView.setCustomSpacing(Warp.Spacing.spacing25, after: addressLabel)
        textStackView.setCustomSpacing(Warp.Spacing.spacing100, after: titleLabel)
        textStackView.setCustomSpacing(Warp.Spacing.spacing50, after: descriptionPrimaryLabel)
        textStackView.setCustomSpacing(Warp.Spacing.spacing100, after: descriptionSecondaryLabel)

        contentView.addSubview(infoStackView)
        contentView.addSubview(statusBadgeView)
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
            rootStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing200),
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

            statusBadgeView.topAnchor.constraint(equalTo: topAnchor, constant: Warp.Spacing.spacing100),
            statusBadgeView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing100),

            sortingDetailLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusBadgeView.leadingAnchor, constant: -Warp.Spacing.spacing100),
            addressLabel.trailingAnchor.constraint(lessThanOrEqualTo: statusBadgeView.leadingAnchor, constant: -Warp.Spacing.spacing100),

            commentView.trailingAnchor.constraint(equalTo: rootStackView.trailingAnchor, constant: -Warp.Spacing.spacing200)
        ])
    }

    // MARK: - Private methods

    @objc private func moreButtonTapped() {
        delegate?.favoriteAdView(self, didSelectMoreButton: moreButton)
    }

    private func configureCommentView() {
        if let comment = viewModel?.comment, !comment.isEmpty, !isCommentViewHidden {
            let title = viewModel?.commentAlertTitle ?? ""
            updateCommentAlert(title: title, text: comment)
            commentView.accessibilityLabel = title.isEmpty ? comment : "\(title): \(comment)"
            commentView.isHidden = false
        } else {
            commentView.isHidden = true
        }
    }

    private func updateCommentAlert(title: String, text: String) {
        commentHostingController.rootView = CommentAlertView(title: title, text: text)
    }

    private func updateStatusBadge(from ribbonViewModel: RibbonViewModel) {
        statusBadgeHostingController.rootView = StatusBadgeView(
            text: ribbonViewModel.title,
            variant: Warp.BadgeVariant(ribbonStyle: ribbonViewModel.style)
        )
        statusBadgeView.accessibilityLabel = ribbonViewModel.title
    }

    private func label(style: Warp.Typography, textColor: UIColor, numberOfLines: Int, isHidden: Bool = true) -> Label {
        let label = Label(
            style: style,
            numberOfLines: numberOfLines,
            textColor: textColor,
            withAutoLayout: true
        )
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.isHidden = isHidden
        return label
    }
}

private struct CommentAlertView: View {
    let title: String
    let text: String

    var body: some View {
        HStack(alignment: .center, spacing: Warp.Spacing.spacing100) {
            Warp.IconView(.fileText, size: .small, color: Warp.Token.iconSubtle)
            Text(text)
                .font(from: Warp.Typography.caption)
                .foregroundStyle(Warp.Token.text)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, Warp.Spacing.spacing100)
        .padding(.horizontal, Warp.Spacing.spacing150)
        .background(Warp.Token.surfaceSunken, in: RoundedRectangle(cornerRadius: Warp.Border.borderRadius100))
        .padding(.leading, FavoriteAdView.adImageWidth + Warp.Spacing.spacing200 - Warp.Spacing.spacing150)
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title.isEmpty ? text : "\(title): \(text)")
    }
}

private struct StatusBadgeView: View {
    let text: String
    let variant: Warp.BadgeVariant

    var body: some View {
        Warp.Badge(text: text, variant: variant)
    }
}

private extension Warp.BadgeVariant {
    init(ribbonStyle: RibbonView.Style) {
        switch ribbonStyle {
        case .default: self = .neutral
        case .success: self = .success
        case .warning: self = .warning
        case .error: self = .negative
        case .disabled: self = .disabled
        case .sponsored: self = .sponsored
        }
    }
}
