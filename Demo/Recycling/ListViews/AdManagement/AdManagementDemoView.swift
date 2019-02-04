//
//  Copyright © FINN.no AS. All rights reserved.
//

import FinniversKit

public class AdManagementDemoView: UIView {
    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserAdManagementStatisticsCell.self)
        tableView.separatorStyle = .none
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        backgroundColor = .ice
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
        cell.itemModels = [StatisticsItemModel(type: .seen, valueString: "968", text: "har sett annonsen"),
                           StatisticsItemModel(type: .favourited, valueString: "16", text: "har lagret annonsen"),
                           StatisticsItemModel(type: .email, valueString: "1337", text: "har fått e-post om annonsen")]
        return cell
    }
}

extension AdManagementDemoView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
}
