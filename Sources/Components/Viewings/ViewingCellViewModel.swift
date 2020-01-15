//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct ViewingCellViewModel {

    let weekday: String?
    let month: String?
    let date: String?
    let timeInterval: String?

    public init(weekday: String?, month: String?, date: String?, timeInterval: String?) {
        self.weekday = weekday
        self.month = month
        self.date = date
        self.timeInterval = timeInterval
    }
}
