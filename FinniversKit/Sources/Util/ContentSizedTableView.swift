//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

final class ContentSizedTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        return contentSize
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
}
