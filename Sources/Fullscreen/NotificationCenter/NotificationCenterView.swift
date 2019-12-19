//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol NotificationCenterViewDataSource: AnyObject {
    func numberOfSections(in view: NotificationCenterView) -> Int
    func notificationCenterView(_ view: NotificationCenterView, numberOfRowsIn section: Int) -> Int
    func notificationCenterView(_ view: NotificationCenterView, modelForRowAt indexPath: IndexPath) -> NotificationCenterCellModel
}

public class NotificationCenterView: UIView {

    public weak var dataSource: NotificationCenterViewDataSource?

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.register(NotificationCenterCell.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NotificationCenterView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        dataSource?.numberOfSections(in: self) ?? 0
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource?.notificationCenterView(self, numberOfRowsIn: section) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource?.notificationCenterView(self, modelForRowAt: indexPath)
        let cell = tableView.dequeue(NotificationCenterCell.self, for: indexPath)
        cell.configure(with: model)
        return cell
    }
}

private extension NotificationCenterView {
    func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
    }
}
