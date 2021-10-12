//
//  Copyright © 2021 FINN AS. All rights reserved.
//

import Foundation

public struct RecentlySavedViewModel: Hashable {
    public var id: String
    public var title: String
    
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id + title)
    }
}
