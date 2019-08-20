//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public struct FavoriteActionViewModel {
    enum Kind {
        case edit
        case changeName
        case share
        case copyLink(buttonTitle: String)
        case delete
    }

    let title: String
}
