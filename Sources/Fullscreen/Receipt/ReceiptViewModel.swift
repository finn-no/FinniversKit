//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol ReceiptViewModel {
    var title: String { get }
    var body: String { get }
    var navigateToAdButtonText: String { get }
    var navigateToMyAdsButtonText: String { get }
    var createNewAdButtonText: String { get }
}

public extension ReceiptViewModel {
    var accessibilityLabel: String {
        return [title, body].joined(separator: ". ")
    }
}
