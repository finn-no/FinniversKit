//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

class NotificationCenterView: UIView {

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    
}

private extension NotificationCenterView {
    func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
    }
}
