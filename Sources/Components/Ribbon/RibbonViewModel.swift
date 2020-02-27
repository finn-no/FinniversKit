//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public struct RibbonViewModel {
    public let style: RibbonView.Style
    public let title: String

    public init(style: RibbonView.Style, title: String) {
        self.style = style
        self.title = title
    }
}
