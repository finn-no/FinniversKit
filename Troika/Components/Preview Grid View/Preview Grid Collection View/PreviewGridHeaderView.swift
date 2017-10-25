//
//  Copyright © 2017 FINN.no AS, Inc. All rights reserved.
//

import Foundation

internal class PreviewGridHeaderView: UICollectionReusableView {

    var contentView: UIView? {
        willSet {
            contentView?.removeFromSuperview()
        }
        didSet {
            guard let contentView = contentView else {
                return // View was removed
            }

            addSubview(contentView)

            contentView.translatesAutoresizingMaskIntoConstraints = false

            contentView.topAnchor.constraint(equalTo: topAnchor).isActive = true
            contentView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            contentView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        }
    }
}
