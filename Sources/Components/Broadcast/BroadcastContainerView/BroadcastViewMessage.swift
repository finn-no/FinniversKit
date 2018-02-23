//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct Broadcast {
    public let id: Int
    public let message: String

    public init(id: Int, message: String) {
        self.id = id
        self.message = message
    }
}
