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
    public init(type: StatisticsItemType, valueString: String, text: String) {
        self.type = type
        self.valueString = valueString
        self.text = text
    }

    public var type: StatisticsItemType
    public var valueString: String
    public var text: String
}
