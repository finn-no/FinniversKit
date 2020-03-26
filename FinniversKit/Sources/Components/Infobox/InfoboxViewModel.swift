//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol InfoboxViewModel {
    var title: String { get }
    var detail: String { get }
    var primaryButtonTitle: String { get }
    var secondaryButtonTitle: String { get }
}
