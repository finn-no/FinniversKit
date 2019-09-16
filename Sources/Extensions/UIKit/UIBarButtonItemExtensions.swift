//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public extension UIBarButtonItem {
    func setTitleTextAttributes(_ attributes: [NSAttributedString.Key: Any]?) {
        let states: [UIControl.State] = [.normal, .highlighted, .focused, .disabled]

        states.forEach {
            setTitleTextAttributes(attributes, for: $0)
        }
    }
}
