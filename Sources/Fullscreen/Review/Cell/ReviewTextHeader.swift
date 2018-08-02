//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation
import UIKit

class ReviewTextHeader: UITableViewHeaderFooterView {
    static let identifier = "ReviewTextCell"

    lazy var title: Label = {
        let label = Label(style: .title3)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var subtitle: Label = {
        let label = Label(style: .body(.stone))
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white

        contentView.addSubview(title)
        contentView.addSubview(subtitle)
        NSLayoutConstraint.activate([
            title.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: .mediumLargeSpacing),
            title.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -.mediumLargeSpacing),

            subtitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: .mediumLargeSpacing),
            subtitle.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -.mediumLargeSpacing),

            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumSpacing),
            title.bottomAnchor.constraint(equalTo: subtitle.topAnchor, constant: -.mediumSpacing),

            subtitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumSpacing),
        ])
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        title.text = ""
        subtitle.text = ""
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
