//
//  Copyright © FINN.no AS. All rights reserved.
//

import FinniversKit

public class AdManagementDemoView: UIView {
    private let estimatedRowHeight: CGFloat = 200

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.dataSource = self
        tableView.register(UserAdManagementStatisticsCell.self)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .ice
        tableView.estimatedRowHeight = estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public override func didMoveToSuperview() {
        tableView.reloadData()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
    }
}

extension AdManagementDemoView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UserAdManagementStatisticsCell.self, for: indexPath)
        cell.itemModels = [StatisticsItemModel(type: .seen, value: 968, text: "har sett annonsen"),
                           StatisticsItemModel(type: .favourited, value: 16, text: "har lagret annonsen"),
                           StatisticsItemModel(type: .email, value: 1337, text: "har fått e-post om annonsen")]
        return cell
    }
}
