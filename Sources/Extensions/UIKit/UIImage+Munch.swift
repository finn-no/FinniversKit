//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

extension UIImage {
    convenience init?(frameworkImageNamed name: String) {
        self.init(named: name, in: .munch, compatibleWith: nil)
    }
}
