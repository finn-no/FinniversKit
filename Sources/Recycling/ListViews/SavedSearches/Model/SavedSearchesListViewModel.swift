//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol SavedSearchesListViewModel {
    var title: String { get }
    var subtitle: String? { get }
    var accessibilityLabel: String { get }
    var settingsButtonAccessibilityLabel: String { get }
}

public extension SavedSearchesListViewModel {
    var accessibilityLabel: String {
        // TODO: Maybe should add the push types here
        return title
    }
}
