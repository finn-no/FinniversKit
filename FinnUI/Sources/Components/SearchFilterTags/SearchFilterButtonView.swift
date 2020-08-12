//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

final class SearchFilterButtonView: UIView {

    // MARK: - Private properties

    private lazy var titleLabel: UILabel = {
        let label = InsetLabel(withAutoLayout: true)
        label.font = SearchFilterButtonView.titleFont
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .textPrimary
        label.textAlignment = .left
        label.lineBreakMode = .byClipping
        return label
    }()

    private lazy var filterIcon: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.tintColor = .iconPrimary
        return imageView
    }()

    var contentWidth: CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: SearchFilterTagsView.height)
        let boundingBox = title.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: SearchFilterButtonView.titleFont],
            context: nil
        )
        return ceil(boundingBox.width) + 3 * SearchFilterButtonView.padding + SearchFilterButtonView.iconWidth
    }

    private let title: String

    // MARK: - Init

    init(title: String, icon: UIImage) {
        self.title = title
        super.init(frame: .zero)
        titleLabel.text = title
        filterIcon.image = icon
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = .borderColor
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgPrimary

        layer.cornerRadius = 4
        layer.borderColor = .borderColor
        layer.borderWidth = 1

        addSubview(filterIcon)
        addSubview(titleLabel)

        let padding = SearchFilterButtonView.padding
        let iconWidth = SearchFilterButtonView.iconWidth

        NSLayoutConstraint.activate([
            filterIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            filterIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            filterIcon.widthAnchor.constraint(equalToConstant: iconWidth),
            filterIcon.heightAnchor.constraint(equalTo: filterIcon.widthAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: filterIcon.trailingAnchor, constant: padding),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}

// MARK: - Size calculations

extension SearchFilterButtonView {
    static let height: CGFloat = 30
    static let minWidth: CGFloat = iconWidth + 2 * padding

    private static let titleFont = UIFont.detailStrong
    static let padding: CGFloat = .spacingS
    private static var iconWidth: CGFloat = 10
}

// MARK: - Private extensions

private extension CGColor {
    class var borderColor: CGColor {
        UIColor.dynamicColorIfAvailable(defaultColor: .sardine, darkModeColor: .darkSardine).cgColor
    }
}

// MARK: - Private classes

private class InsetLabel: UILabel {
    let trailingInset: CGFloat = SearchFilterButtonView.padding

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(trailing: trailingInset)
        super.drawText(in: rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + trailingInset,
                      height: size.height)
    }
}
