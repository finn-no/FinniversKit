//
// Created by Torp, Thomas on 03/09/2018.
// Copyright (c) 2018 FINN AS. All rights reserved.
//

import Foundation
import UIKit

class ReviewTextFooter: UITableViewHeaderFooterView {
    lazy var title: Button = {
        let label = Button(style: .link)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var subtitle: Button = {
        let label = Button(style: .link)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white

        contentView.addSubview(title)
        contentView.addSubview(subtitle)
        NSLayoutConstraint.activate([
                                        title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),

                                        subtitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),

                                        title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumSpacing),
                                        title.bottomAnchor.constraint(equalTo: subtitle.topAnchor, constant: -.mediumSpacing),

                                        subtitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumSpacing),
                                    ])
    }

    public override func prepareForReuse() {
        super.prepareForReuse()
        title.setTitle("", for: .normal)
        subtitle.setTitle("", for: .normal)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
