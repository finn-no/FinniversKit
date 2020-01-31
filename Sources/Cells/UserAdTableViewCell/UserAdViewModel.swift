//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public protocol UserAdViewModel {
    var title: String { get }
    var subtitle: String? { get }
    var detail: String? { get }
    var ribbonModel: UserAdViewRibbonViewModel { get }
    var imagePath: String? { get }
}

public struct UserAdViewRibbonViewModel {
    let title: String
    let style: RibbonView.Style

    public init(title: String, style: RibbonView.Style) {
        self.title = title
        self.style = style
    }
}
