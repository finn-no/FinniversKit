//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct BroadcastViewMessage {
    public let id: String
    public let message: String

    public init(id: String, message: String) {
        self.id = id
        self.message = message
    }
}
