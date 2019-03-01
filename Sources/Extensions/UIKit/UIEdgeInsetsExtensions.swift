//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public extension UIEdgeInsets {
    public static func leadingInset(_ leadingInset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, leading: leadingInset, bottom: 0, trailing: 0)
    }

    init(all inset: CGFloat) {
        self.init(top: inset, leading: inset, bottom: inset, trailing: inset)
    }
}
