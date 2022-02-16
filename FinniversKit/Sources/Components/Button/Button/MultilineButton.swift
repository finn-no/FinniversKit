import UIKit

public class MultilineButton: Button {

    // MARK: - Public properties

    public override var intrinsicContentSize: CGSize {
        guard let titleSize = titleLabel?.intrinsicContentSize else { return .zero }

        let paddings = style.paddings(forSize: size)
        let imageSize = imageView?.image?.size ?? .zero

        return CGSize(
            width: ceil(titleSize.width) + style.margins.left + style.margins.right + paddings.left + paddings.right + imageSize.width,
            height: ceil(titleSize.height) + style.margins.top + style.margins.bottom + paddings.top + paddings.bottom
        )
    }

    // MARK: - Init

    public override init(style: Style, size: Size, withAutoLayout: Bool) {
        super.init(style: style, size: size, withAutoLayout: withAutoLayout)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        titleLabel?.lineBreakMode = .byWordWrapping
        titleLabel?.numberOfLines = 0
    }

    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.preferredMaxLayoutWidth = titleLabel?.frame.size.width ?? 0
    }
}
