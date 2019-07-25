//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

open class SelectableTableViewCell: UITableViewCell {

    // MARK: - Init

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        let selectedBackgroundView = UIView()
        selectedBackgroundView.backgroundColor = .defaultCellSelectedBackgroundColor
        self.selectedBackgroundView = selectedBackgroundView
    }
}
