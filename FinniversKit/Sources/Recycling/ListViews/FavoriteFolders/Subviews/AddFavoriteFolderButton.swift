//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

final class AddFavoriteFolderButton: UIButton {
    static let imageSize: CGFloat = 40

    public override var isHighlighted: Bool {
        didSet {
            updateAlpha(isHighlighted: isHighlighted)
        }
    }

    public override var isSelected: Bool {
        didSet {
            updateAlpha(isHighlighted: isSelected)
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: frame.width, height: AddFavoriteFolderButton.imageSize)
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()

        guard let imageView = imageView, let titleLabel = titleLabel else {
            return
        }

        let imageSize = AddFavoriteFolderButton.imageSize

        imageView.frame = CGRect(
            x: .spacingM,
            y: (bounds.height - imageSize) / 2,
            width: imageSize,
            height: imageSize
        )

        titleLabel.frame.origin.x = imageView.frame.maxX + .spacingM
        titleLabel.frame.size.width = bounds.width - .spacingM - titleLabel.frame.minX
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgPrimary

        imageView?.backgroundColor = .bgTertiary
        imageView?.tintColor = .btnAction
        imageView?.layer.masksToBounds = true
        imageView?.contentMode = .center
        imageView?.layer.cornerRadius = 12

        let image = UIImage(named: .favoritesPlus).withRenderingMode(.alwaysTemplate)
        setImage(image, for: .normal)
        setImage(image, for: .highlighted)

        titleLabel?.font = .bodyStrong
        setTitleColor(.btnAction, for: .normal)
    }

    private func updateAlpha(isHighlighted: Bool) {
        alpha = isHighlighted ? 0.6 : 1
    }
}
