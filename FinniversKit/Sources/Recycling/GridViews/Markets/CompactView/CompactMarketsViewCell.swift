import UIKit

class CompactMarketsViewCell: UICollectionViewCell {

    // MARK: - Internal properties

    var model: MarketsViewModel? {
        didSet {
            iconImageView.image = model?.iconImage
            titleLabel.text = model?.title
            accessibilityLabel = model?.accessibilityLabel

            let showExternalLinkIcon = model?.showExternalLinkIcon ?? false
            externalLinkImageView.isHidden = !showExternalLinkIcon
        }
    }

    // MARK: - Private properties

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(axis: .horizontal, spacing: .spacingS, withAutoLayout: true)
        stackView.addArrangedSubviews([iconImageView, titleLabel, externalLinkImageView])
        stackView.alignment = .center
        return stackView
    }()

    private lazy var iconImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var externalLinkImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .webview).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .externalLinkColor
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: Self.titleLabelStyle, withAutoLayout: true)
        label.textAlignment = .left
        return label
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

    // MARK: - Setup

    private func setup() {
        isAccessibilityElement = true
        backgroundColor = .clear

        contentView.addSubview(stackView)
        stackView.fillInSuperview(insets: Self.contentInsets.forLayoutConstraints)

        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: Self.iconImageSize.width),
            iconImageView.heightAnchor.constraint(equalToConstant: Self.iconImageSize.height),
            externalLinkImageView.widthAnchor.constraint(equalToConstant: Self.externalLinkImageSize.width),
            externalLinkImageView.heightAnchor.constraint(equalToConstant: Self.externalLinkImageSize.height),
        ])
    }

    // MARK: - Superclass Overrides

    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        titleLabel.text = ""
        accessibilityLabel = ""
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 1
        layer.borderColor = UIColor.externalLinkColor.cgColor
    }
}

// MARK: - Size calculations

extension CompactMarketsViewCell {
    static let borderWidth: CGFloat = 1
    static let contentInsets = UIEdgeInsets(vertical: 10, horizontal: .spacingM)
    static let titleLabelStyle = Label.Style.caption
    static let cellHeight: CGFloat = 44
    static let itemSpacing = CGFloat.spacingS
    static let iconImageSize = CGSize(width: 24, height: 24)
    static let externalLinkImageSize = CGSize(width: 16, height: 16)

    static func size(for model: MarketsViewModel) -> CGSize {
        var widths: [CGFloat] = [
            contentInsets.leading,
            iconImageSize.width,
            itemSpacing,
            width(for: model.title)
        ]

        if model.showExternalLinkIcon {
            widths.append(contentsOf: [
                itemSpacing,
                externalLinkImageSize.width
            ])
        }

        widths.append(contentInsets.trailing)

        let heights: [CGFloat] = [
            borderWidth,
            contentInsets.top,
            iconImageSize.height,
            contentInsets.bottom,
            borderWidth
        ]

        return CGSize(width: widths.reduce(0, +), height: heights.reduce(0, +))
    }

    private static func width(for title: String) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: cellHeight)
        let boundingBox = title.boundingRect(
            with: constraintRect,
            options: .usesLineFragmentOrigin,
            attributes: [.font: titleLabelStyle.font],
            context: nil
        )

        return ceil(boundingBox.width)
    }
}

// MARK: - Private extensions

private extension UIColor {
    class var externalLinkColor: UIColor {
        dynamicColorIfAvailable(defaultColor: .sardine, darkModeColor: .darkSardine)
    }
}

private extension UIEdgeInsets {
    var forLayoutConstraints: UIEdgeInsets {
        UIEdgeInsets(top: top, leading: leading, bottom: -bottom, trailing: -trailing)
    }
}
