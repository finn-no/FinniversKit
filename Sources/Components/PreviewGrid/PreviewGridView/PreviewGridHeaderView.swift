//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

class PreviewGridHeaderView: UICollectionReusableView {

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

            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: topAnchor),
                contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
                contentView.leftAnchor.constraint(equalTo: leftAnchor),
            ])
        }
    }
}
