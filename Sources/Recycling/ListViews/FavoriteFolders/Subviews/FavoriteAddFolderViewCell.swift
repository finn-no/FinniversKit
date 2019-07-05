//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

final class FavoriteAddFolderViewCell: UITableViewCell {
    private lazy var addFolderView = FavoriteAddFolderView(withAutoLayout: true)

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addFolderView.isTopShadowHidden = true
        contentView.addSubview(addFolderView)
        addFolderView.fillInSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    func configure(withTitle title: String) {
        addFolderView.configure(withTitle: title)
    }
}
