//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol ConsentViewModel {
    var yesButtonTitle: String { get }
    var noButtonTitle: String { get }
    var cancelButtonTitle: String { get }
    var descriptionTitle: String { get }
    var descriptionBodyText: String { get }
}
