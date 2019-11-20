//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit
import Bootstrap

class SettingsViewCell: BasicTableViewCell {

    // MARK: - Views

    private lazy var hairLine: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .tableViewSeparator
        return view
    }()

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func setup() {
           contentView.addSubview(hairLine)

           NSLayoutConstraint.activate([
               hairLine.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
               hairLine.trailingAnchor.constraint(equalTo: trailingAnchor),
               hairLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
               hairLine.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
           ])
       }

    // MARK: - Overrides

    override func prepareForReuse() {
        super.prepareForReuse()
        configure(with: nil, isLastItem: false)
    }
}

extension SettingsViewCell {
    func configure(with model: SettingsViewCellModel?, isLastItem: Bool) {
        if let model = model {
            super.configure(with: model)
        }

        hairLine.isHidden = isLastItem
    }
}
