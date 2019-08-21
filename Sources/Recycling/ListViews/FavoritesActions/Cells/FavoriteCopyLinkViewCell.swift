//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class FavoriteCopyLinkViewCell: UITableViewCell {
    // MARK: - Setup

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        isAccessibilityElement = true
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
    }
}
