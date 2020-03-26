//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct ViewingsViewModel {

    let title: String
    let addToCalendarButtonTitle: String
    let viewings: [ViewingCellViewModel]
    let note: String?

    public init(title: String, addToCalendarButtonTitle: String, viewings: [ViewingCellViewModel] = [], note: String?) {
        self.title = title
        self.addToCalendarButtonTitle = addToCalendarButtonTitle
        self.viewings = viewings
        self.note = note
    }
}
