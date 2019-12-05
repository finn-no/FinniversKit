//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public struct StatisticsModel {
    public struct HeaderModel {
        public let title: String
        public let fullStatisticsTitle: String

        public init(title: String, fullStatisticsTitle: String) {
            self.title = title
            self.fullStatisticsTitle = fullStatisticsTitle
        }
    }

    public let header: HeaderModel?
    public let statisticItems: [StatisticsItemModel]

    public init(header: HeaderModel? = nil, statisticItems: [StatisticsItemModel] = []) {
        self.header = header
        self.statisticItems = statisticItems
    }
}
