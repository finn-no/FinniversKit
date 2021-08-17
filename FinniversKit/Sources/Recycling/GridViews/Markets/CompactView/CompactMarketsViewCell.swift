import UIKit

class CompactMarketsViewCell: UICollectionViewCell {

    // MARK: - Internal properties

    var model: MarketsViewModel? {
        didSet {
            titleLabel.text = model?.title
            accessibilityLabel = model?.accessibilityLabel
        }
    }

    // MARK: - Private properties

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
        backgroundColor = Config.colorProvider.tileBackgroundColor

        contentView.addSubview(titleLabel)
        
        titleLabel.fillInSuperview(insets: Self.contentInsets.forLayoutConstraints)
    }

    // MARK: - Superclass Overrides

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        accessibilityLabel = ""
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
    }
}

// MARK: - Size calculations

extension CompactMarketsViewCell {
    static let borderWidth: CGFloat = 1
    static let contentInsets = UIEdgeInsets(vertical: 10, horizontal: .spacingM)
    static let titleLabelStyle = Label.Style.captionStrong
    static let cellHeight: CGFloat = 34
    static let itemSpacing = CGFloat.spacingS

    static func size(for model: MarketsViewModel) -> CGSize {
        var widths: [CGFloat] = [
            contentInsets.leading,
            itemSpacing,
            width(for: model.title)
        ]

        widths.append(contentInsets.trailing)

        let heights: [CGFloat] = [
            borderWidth,
            contentInsets.top,
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

private extension UIEdgeInsets {
    var forLayoutConstraints: UIEdgeInsets {
        UIEdgeInsets(top: top, leading: leading, bottom: -bottom, trailing: -trailing)
    }
}
