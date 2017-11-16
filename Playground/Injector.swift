//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika

extension UIViewController {
    #if DEBUG
        @objc func injected() {
            for subview in view.subviews {
                subview.removeFromSuperview()
            }

            viewDidLoad()
        }
    #endif
}

extension UIView {
    #if DEBUG
        @objc func injected() {
            for subview in subviews {
                subview.removeFromSuperview()
            }

            if let view = self as? Injectable {
                view.setup()
            }
        }
    #endif
}
