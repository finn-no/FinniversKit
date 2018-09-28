//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation
import UIKit

class ReviewTextHeader: UITableViewHeaderFooterView {
    lazy var title: Label = {
        let label = Label(style: .title3)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        contentView.addSubview(title)

        let inset = UIEdgeInsets(top: .mediumLargeSpacing,
                                 left: .mediumLargeSpacing,
                                 bottom: -.mediumLargeSpacing,
                                 right: -.mediumLargeSpacing)
        title.fillInSuperview(insets: inset, isActive: true)
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        title.text = ""
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
