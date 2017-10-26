//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

internal extension UIImage {

    convenience init?(frameworkImageNamed name: String) {
        self.init(named: name, in: .troika, compatibleWith: nil)
    }
}
