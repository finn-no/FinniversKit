//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation
import UIKit

public struct UserAdViewRibbonViewModel {
    let title: String
    let style: RibbonView.Style

    public init(title: String, style: RibbonView.Style) {
        self.title = title
        self.style = style
    }
}

public enum UserAdViewStyle {
    case regular
    case compact
}

public protocol UserAdViewModel {
    var title: String { get }
    var ribbon: UserAdViewRibbonViewModel { get }
    var imagePath: String? { get }
}

public class UserAdTableViewCell: UITableViewCell {

    // MARK: - External properties

    public var remoteImageViewDataSource: RemoteImageViewDataSource? {
        didSet {
            adImageView.dataSource = remoteImageViewDataSource
        }
    }

    private var style: UserAdViewStyle? = .regular
    private var model: UserAdViewModel?

    private lazy var adImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.layer.cornerRadius = .mediumLargeSpacing
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: false)
        label.numberOfLines = 2
        label.backgroundColor = .clear
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .detailStrong, withAutoLayout: false)
        label.backgroundColor = .clear
        label.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return label
    }()

    private lazy var ribbonView: RibbonView = RibbonView(withAutoLayout: true)

    private lazy var descriptionStack: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .leading
        return stackView
    }()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        isAccessibilityElement = true
        backgroundColor = .bgPrimary
        selectionStyle = .none

        contentView.addSubview(adImageView)
        contentView.addSubview(descriptionStack)
        contentView.addSubview(ribbonView)

        descriptionStack.addArrangedSubview(titleLabel)
        descriptionStack.addArrangedSubview(subtitleLabel)

        NSLayoutConstraint.activate([
            adImageView.topAnchor.constraint(equalTo: descriptionStack.topAnchor),
            adImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -.largeSpacing),
            adImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumSpacing),
            adImageView.heightAnchor.constraint(equalToConstant: .veryLargeSpacing),
            adImageView.widthAnchor.constraint(equalToConstant: .veryLargeSpacing),

            descriptionStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .largeSpacing),
            descriptionStack.leadingAnchor.constraint(equalTo: adImageView.trailingAnchor, constant: .mediumLargeSpacing),
            descriptionStack.trailingAnchor.constraint(equalTo: ribbonView.leadingAnchor, constant: .verySmallSpacing),
            descriptionStack.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),

            ribbonView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .smallSpacing),
            ribbonView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumSpacing),
        ])
    }

    public func configure(with style: UserAdViewStyle, model: UserAdViewModel) {
        self.style = style
        self.model = model

        separatorInset = .leadingInset(.mediumSpacing + .veryLargeSpacing)

        titleLabel.text = model.title
        subtitleLabel.text = model.title
        ribbonView.style = model.ribbon.style
        ribbonView.title = model.ribbon.title
    }

    public func loadImage() {
        if let imagePath = model?.imagePath {
            let color: UIColor? = [.toothPaste, .mint, .banana, .salmon].randomElement()
            adImageView.loadImage(for: imagePath, imageWidth: .veryLargeSpacing, loadingColor: color, fallbackImage: UIImage(named: .noImage))
        }
    }

    // MARK: - Superclass Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()
        adImageView.cancelLoading()
        adImageView.image = nil
        titleLabel.text = nil
        subtitleLabel.text = nil
        ribbonView.title = ""
        ribbonView.style = .default
    }

}
