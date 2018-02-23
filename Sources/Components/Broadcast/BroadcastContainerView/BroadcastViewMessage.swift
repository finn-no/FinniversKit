//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct Broadcast: Equatable {
    public let id: Int
    public let message: String

    public init(id: Int, message: String) {
        self.id = id
        self.message = message
    }

    public static func == (lhs: Broadcast, rhs: Broadcast) -> Bool {
        return lhs.id == rhs.id && lhs.message == rhs.message
    }
}
