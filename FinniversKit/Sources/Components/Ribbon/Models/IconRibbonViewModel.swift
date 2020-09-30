//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public struct IconRibbonViewModel {
    public let style: RibbonView.Style
    public let icon: UIImage

    public init(style: RibbonView.Style, icon: UIImage) {
        self.style = style
        self.icon = icon
    }
}
