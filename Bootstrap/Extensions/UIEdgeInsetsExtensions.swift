//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public extension UIEdgeInsets {
    static func leadingInset(_ leadingInset: CGFloat) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, leading: leadingInset, bottom: 0, trailing: 0)
    }
}
