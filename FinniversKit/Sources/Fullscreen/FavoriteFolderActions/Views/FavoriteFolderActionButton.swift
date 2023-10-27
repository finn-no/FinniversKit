//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

final class FavoriteFolderActionButton: UIButton {
    let action: FavoriteFolderAction
    private let enabledTintColor: UIColor

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .textDisabled
        view.isHidden = isSeparatorHidden
        return view
    }()

    var isSeparatorHidden = true {
        didSet {
            separatorView.isHidden = isSeparatorHidden
        }
    }

    // MARK: - Init

    init(action: FavoriteFolderAction, title: String, icon: ImageAsset, tintColor: UIColor = .iconPrimary) {
        self.action = action
        self.enabledTintColor = tintColor
        super.init(frame: .zero)

        titleLabel?.font = .bodyStrong
        setTitleColor(tintColor, for: .normal)
        setTitleColor(.btnDisabled, for: .disabled)
        setTitle(title, for: .normal)

        imageView?.tintColor = tintColor
        let image = UIImage(named: icon).withRenderingMode(.alwaysTemplate)
        setImage(image, for: .normal)
        setImage(image, for: .disabled)
        setImage(image, for: .highlighted)

        addSubview(separatorView)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    override var isHighlighted: Bool {
        didSet {
            updateBackground()
        }
    }

    override var isSelected: Bool {
        didSet {
            updateBackground()
        }
    }

    override var isEnabled: Bool {
        didSet {
            imageView?.tintColor = isEnabled ? enabledTintColor : .btnDisabled
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let imageView = imageView, let titleLabel = titleLabel else { return }

        imageView.frame.size = CGSize(width: 24, height: 24)
        imageView.frame.origin.x = .spacingM

        titleLabel.frame.origin.x = imageView.frame.maxX + .spacingM
        titleLabel.frame.size.width = bounds.width - titleLabel.frame.origin.x - .spacingM

        let separatorHeight = 1 / UIScreen.main.scale
        separatorView.frame.origin = CGPoint(x: titleLabel.frame.minX, y: bounds.height - separatorHeight)
        separatorView.frame.size = CGSize(width: bounds.width - separatorView.frame.minX, height: separatorHeight)
    }

    // MARK: - Private

    private func updateBackground() {
        backgroundColor = (isHighlighted || isSelected) ? .defaultCellSelectedBackgroundColor : .background
    }
}
