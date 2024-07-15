//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public extension UITableViewCell {
    func setDefaultSelectedBackgound() {
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .backgroundActive
        self.selectedBackgroundView = selectedBackgroundView
    }
}
