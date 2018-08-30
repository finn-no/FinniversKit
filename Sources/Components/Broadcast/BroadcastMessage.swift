//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct BroadcastMessage: Hashable, Decodable {
    public let id: Int
    public let text: String
    public let broadcastAreas: [String]

    enum CodingKeys: String, CodingKey {
        case text = "message"
        case id, broadcastAreas
    }

    public init(id: Int, text: String) {
        self.id = id
        self.text = text
        self.broadcastAreas = []
    }

    public var hashValue: Int {
        return id.hashValue
    }
}
