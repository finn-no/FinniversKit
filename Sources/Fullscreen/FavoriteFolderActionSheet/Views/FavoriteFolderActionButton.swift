//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

final class FavoriteFolderActionButton: UIButton {
    let action: FavoriteFolderAction
    private let enabledTintColor: UIColor

    private lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .sardine
        view.isHidden = isSeparatorHidden
        return view
    }()

    var isSeparatorHidden = true {
        didSet {
            separatorView.isHidden = isSeparatorHidden
        }
    }

    // MARK: - Init

    init(action: FavoriteFolderAction, title: String, icon: FinniversImageAsset, tintColor: UIColor = .licorice) {
        self.action = action
        self.enabledTintColor = tintColor
        super.init(frame: .zero)

        titleLabel?.font = .bodyStrong
        setTitleColor(tintColor, for: .normal)
        setTitleColor(.sardine, for: .disabled)
        setTitle(title, for: .normal)

        imageView?.tintColor = tintColor
        adjustsImageWhenHighlighted = false
        setImage(UIImage(named: icon).withRenderingMode(.alwaysTemplate), for: .normal)
        setImage(UIImage(named: icon).withRenderingMode(.alwaysTemplate), for: .disabled)

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
            imageView?.tintColor = isEnabled ? enabledTintColor : .sardine
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        guard let imageView = imageView, let titleLabel = titleLabel else { return }

        imageView.frame.size = CGSize(width: 24, height: 24)
        imageView.frame.origin.x = .mediumLargeSpacing

        titleLabel.frame.origin.x = imageView.frame.maxX + .mediumLargeSpacing
        titleLabel.frame.size.width = bounds.width - titleLabel.frame.origin.x - .mediumLargeSpacing

        let separatorHeight = 1 / UIScreen.main.scale
        separatorView.frame.origin = CGPoint(x: titleLabel.frame.minX, y: bounds.height - separatorHeight)
        separatorView.frame.size = CGSize(width: bounds.width - separatorView.frame.minX, height: separatorHeight)
    }

    // MARK: - Private

    private func updateBackground() {
        backgroundColor = (isHighlighted || isSelected) ? .defaultCellSelectedBackgroundColor : .bgPrimary
    }
}
