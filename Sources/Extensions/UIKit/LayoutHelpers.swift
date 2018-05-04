//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

extension UIEdgeInsets {
    init(top: CGFloat = 0, leading: CGFloat = 0, bottom: CGFloat = 0, trailing: CGFloat = 0) {
        self.init(top: top, left: leading, bottom: bottom, right: trailing)
    }

    public var leading: CGFloat {
        return left
    }

    public var trailing: CGFloat {
        return right
    }

    public static var zero: UIEdgeInsets {
        return UIEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    }
}
