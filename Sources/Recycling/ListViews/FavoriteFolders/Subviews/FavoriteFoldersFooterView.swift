//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

protocol FavoriteFoldersFooterViewDelegate: AnyObject {
    func favoriteFoldersFooterViewDidSelectButton(_ view: FavoriteFoldersFooterView)
}

final class FavoriteFoldersFooterView: UIView {
    private static let shadowRadius: CGFloat = 3

    weak var delegate: FavoriteFoldersFooterViewDelegate?

    private(set) lazy var button: UIButton = {
        let button = AddFavoriteFolderButton(withAutoLayout: true)
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        return button
    }()

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
        // Make shadow to be on top
        let rect = CGRect(x: 0, y: 0, width: bounds.width, height: layer.shadowRadius)
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

    // MARK: - Actions

    @objc private func handleButtonTap() {
        delegate?.favoriteFoldersFooterViewDidSelectButton(self)
    }
}
