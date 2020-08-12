//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

final class SearchFilterButtonView: UIView {

    // MARK: - Private properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = SearchFilterButtonView.titleFont
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .textPrimary
        label.textAlignment = .center
        return label
    }()

    private lazy var filterIcon: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.tintColor = .iconPrimary
        return imageView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
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
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
        ])
    }

    // MARK: - Internal methods

    func configure(with title: String, icon: UIImage) {
        titleLabel.text = title
        filterIcon.image = icon
    }
}

// MARK: - Size calculations

extension SearchFilterButtonView {
    static let height: CGFloat = 30

    static func width(for title: String) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = title.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: titleFont],
            context: nil
        )

        return ceil(boundingBox.width) + 3 * padding + iconWidth
    }

    private static let titleFont = UIFont.detailStrong
    private static let padding: CGFloat = .spacingS
    private static var iconWidth: CGFloat = 10
}

// MARK: - Private extensions

private extension CGColor {
    class var borderColor: CGColor {
        UIColor.dynamicColorIfAvailable(defaultColor: .sardine, darkModeColor: .darkSardine).cgColor
    }
}
