//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol ReportAdViewModel {
    var radioButtonTitle: String { get }
    var radioButtonFields: [String] { get }
    var descriptionViewTitle: String { get }
    var descriptionViewPlaceholderText: String { get }
    var helpButtonText: String { get }
}
