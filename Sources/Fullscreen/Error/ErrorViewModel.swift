//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol ErrorViewModel {
    var tryAgainButtonTitle: String { get }
    var playButtonTitle: String { get }
}

public extension ErrorViewModel {
    var accessibilityLabel: String {
        return ""
    }
}
