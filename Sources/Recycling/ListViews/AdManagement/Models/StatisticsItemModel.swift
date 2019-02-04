//
//  Copyright © FINN.no AS. All rights reserved.
//
import Foundation

public struct StatisticsItemModel {
    public enum StatisticsItemType {
        case seen
        case favourited
        case email
    }

    // Annoying Swift shortcoming for structs
    public init(type: StatisticsItemType, value: Int, text: String) {
        self.type = type
        self.value = value
        self.text = text
    }

    public var type: StatisticsItemType
    public var value: Int
    public var text: String
}
