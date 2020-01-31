//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation
import UIKit

public class UserAdTableViewCell: UITableViewCell {

    // MARK: - Public properties

    public enum UserAdTableViewCellStyle {
        case regular
        case compact
    }

    public var remoteImageViewDataSource: RemoteImageViewDataSource? {
        didSet {
            adImageView.dataSource = remoteImageViewDataSource
        }
    }

    // MARK: - Private properties

    private var model: UserAdViewModel?

    private var style: UserAdTableViewCellStyle? = .regular {
        didSet {
            setupStyleConstraints()
        }
    }

    private static var regularImageWidth: CGFloat = 80
    private static var compactImageWidth: CGFloat = 50

    private lazy var ribbonView = RibbonView(withAutoLayout: true)

    private lazy var fallbackImage = UIImage(named: .noImage)

    private lazy var adImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.layer.cornerRadius = .mediumLargeSpacing
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .captionStrong)
        label.backgroundColor = .clear
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.isHidden = true
        label.backgroundColor = .clear
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var detailLabel: Label = {
        let label = Label(style: .detail)
        label.isHidden = true
        label.backgroundColor = .clear
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var contentStack: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = .mediumLargeSpacing
        return stackView
    }()

    private lazy var descriptionStack: UIStackView = {
        let stackView = UIStackView(withAutoLayout: false)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 0
        return stackView
    }()

    private lazy var regularConstraints: [NSLayoutConstraint] = [
        contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumLargeSpacing),
        contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumLargeSpacing),

        adImageView.heightAnchor.constraint(equalToConstant: UserAdTableViewCell.regularImageWidth),
        adImageView.widthAnchor.constraint(equalToConstant: UserAdTableViewCell.regularImageWidth),

        ribbonView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumSpacing),
    ]

    private lazy var compactConstraints: [NSLayoutConstraint] = [
        contentStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumSpacing),
        contentStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumSpacing),

        adImageView.heightAnchor.constraint(equalToConstant: UserAdTableViewCell.compactImageWidth),
        adImageView.widthAnchor.constraint(equalToConstant: UserAdTableViewCell.compactImageWidth),

        ribbonView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
    ]

    private lazy var sharedConstraints: [NSLayoutConstraint] = [
        contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
        contentStack.trailingAnchor.constraint(equalTo: ribbonView.leadingAnchor, constant: -.mediumSpacing),

        ribbonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumSpacing),
    ]

    // MARK: - Init

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private methods

    private func setup() {
        isAccessibilityElement = true
        backgroundColor = .bgPrimary
        selectionStyle = .none

        contentView.addSubview(contentStack)
        contentView.addSubview(ribbonView)

        contentStack.addArrangedSubview(adImageView)
        contentStack.addArrangedSubview(descriptionStack)

        descriptionStack.addArrangedSubview(titleLabel)
        descriptionStack.addArrangedSubview(subtitleLabel)
        descriptionStack.addArrangedSubview(detailLabel)

        descriptionStack.setCustomSpacing(.verySmallSpacing, after: titleLabel)
        descriptionStack.setCustomSpacing(.mediumLargeSpacing, after: subtitleLabel)
    }

    private func setupStyleConstraints() {
        NSLayoutConstraint.deactivate(compactConstraints + regularConstraints)

        let constraints = style == .compact ? compactConstraints : regularConstraints
        NSLayoutConstraint.activate(sharedConstraints + constraints)
    }

    // MARK: Public methods

    public func configure(with style: UserAdTableViewCellStyle, model: UserAdViewModel) {
        self.style = style
        self.model = model

        let imageInset = style == .compact ? UserAdTableViewCell.compactImageWidth : UserAdTableViewCell.regularImageWidth
        separatorInset = .leadingInset(.largeSpacing + imageInset)

        ribbonView.style = model.ribbonModel.style
        ribbonView.title = model.ribbonModel.title

        titleLabel.text = model.title
        titleLabel.numberOfLines = style == .compact ? 1 : 2

        if let subtitle = model.subtitle {
            subtitleLabel.text = subtitle
            subtitleLabel.isHidden = false
        }

        if let detail = model.detail {
            detailLabel.text = detail
            detailLabel.isHidden = style == .compact
        }
    }

    // MARK: - Overrides

    public override func prepareForReuse() {
        adImageView.cancelLoading()
        adImageView.image = nil

        ribbonView.title = ""
        ribbonView.style = .default

        titleLabel.text = nil

        [subtitleLabel, detailLabel].forEach {
            $0.text = nil
            $0.isHidden = true
        }

        super.prepareForReuse()
    }

}

// MARK: - ImageLoading

extension UserAdTableViewCell: ImageLoading {

    public func loadImage() {
        if let imagePath = model?.imagePath {
            let loadingColor: UIColor? = [.toothPaste, .mint, .banana, .salmon].randomElement()
            adImageView.loadImage(for: imagePath, imageWidth: .veryLargeSpacing, loadingColor: loadingColor, fallbackImage: fallbackImage)
        }
    }

}
