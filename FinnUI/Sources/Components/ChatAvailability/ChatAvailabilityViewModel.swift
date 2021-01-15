//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol ChatAvailabilityViewModel {
    var title: String { get }
    var text: String { get }
    var actionButtonTitle: String { get }
    var isActionButtonEnabled: Bool { get }

    var isLoading: Bool { get }
    var statusTitle: String? { get }

    var bookTimeTitle: String? { get }
    var bookTimeButtonTitle: String? { get }
}
