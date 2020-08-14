//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public final class ContentSizedTableView: UITableView {
    public override var intrinsicContentSize: CGSize {
        return contentSize
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
}
