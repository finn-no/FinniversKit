//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

final class AddFavoriteFolderViewCell: BasicTableViewCell {
    private lazy var button: UIButton = {
        let button = AddFavoriteFolderButton(withAutoLayout: true)
        button.isUserInteractionEnabled = false
        return button
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    func configure(withTitle title: String) {
        button.setTitle(title, for: .normal)
    }

    private func setup() {
        contentView.addSubview(button)

        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: leadingAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        separatorInset = .leadingInset(.mediumLargeSpacing * 2 + AddFavoriteFolderButton.imageSize)
    }
}
