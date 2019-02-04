import Foundation

struct StatisticsItemModel {
    enum StatisticsItemType {
        case seen
        case favourited
        case email
    }

    var type: StatisticsItemType
    var valueString: String
    var text: String
}
