//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public extension UITableViewCell {
    func setDefaultSelectedBackgound() {
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .defaultCellSelectedBackgroundColor
        self.selectedBackgroundView = selectedBackgroundView
    }
}
