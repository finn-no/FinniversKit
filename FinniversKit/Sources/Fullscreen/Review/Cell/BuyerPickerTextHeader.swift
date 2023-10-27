//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation
import UIKit

class BuyerPickerTextHeader: UITableViewHeaderFooterView {
    lazy var title: Label = {
        let label = Label(style: .title3Strong)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .background
        contentView.addSubview(title)

        let inset = UIEdgeInsets(top: .spacingM,
                                 left: .spacingM,
                                 bottom: -.spacingXL,
                                 right: 0)
        title.fillInSuperview(insets: inset, isActive: true)
    }

    public func centerTitle() {
        title.textAlignment = .center
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        title.text = ""
        title.textAlignment = .natural
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
