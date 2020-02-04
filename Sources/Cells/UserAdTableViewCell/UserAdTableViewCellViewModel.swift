//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public protocol UserAdTableViewCellViewModel {
    var titleText: String { get }
    var subtitleText: String? { get }
    var detailText: String? { get }
    var imagePath: String? { get }
    var ribbon: UserAdTableViewCellRibbonModel { get }
}

public struct UserAdTableViewCellRibbonModel {
    let title: String
    let style: RibbonView.Style

    public init(title: String, style: RibbonView.Style) {
        self.title = title
        self.style = style
    }
}
