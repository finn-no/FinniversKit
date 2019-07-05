//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

final class FavoriteFoldersFooterView: UIView {
    private static let shadowRadius: CGFloat = 2

    private(set) lazy var button = AddFavoriteFolderButton(withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        let rect = CGRect(x: 0, y: -layer.shadowRadius, width: bounds.width, height: layer.shadowRadius)
        layer.shadowPath = UIBezierPath(rect: rect).cgPath
    }

    // MARK: - Setup

    func configure(withTitle title: String) {
        button.setTitle(title, for: .normal)
    }

    private func setup() {
        backgroundColor = .milk
        isAccessibilityElement = true

        layer.masksToBounds = false
        layer.shadowOpacity = 0.3
        layer.shadowRadius = FavoriteFoldersFooterView.shadowRadius
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.black.cgColor

        addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
