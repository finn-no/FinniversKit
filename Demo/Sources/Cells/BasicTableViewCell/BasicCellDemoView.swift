//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

private struct ViewModel: BasicTableViewCellViewModel {
    var title: String
    let subtitle: String? = nil
    let detailText: String? = nil
    let hasChevron: Bool = false
}

class BasicCellDemoView: UIView, Demoable {
    var dismissKind: DismissKind { .button }

    private let viewModels = [
        ViewModel(title: "Hagemøbler"),
        ViewModel(title: "Kattepuser"),
        ViewModel(title: "Mac Mini Pro"),
        ViewModel(title: "Mac Pro Mini"),
        ViewModel(title: "Mac Pro Max")
    ]

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 48
        tableView.register(BasicTableViewCell.self)
        tableView.separatorInset = .leadingInset(frame.width)
        tableView.backgroundColor = .bgPrimary
        tableView.separatorColor = .tableViewSeparator
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BasicCellDemoView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == (viewModels.count - 1)
        if isLastCell {
            cell.separatorInset = .leadingInset(frame.width)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension BasicCellDemoView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(BasicTableViewCell.self, for: indexPath)
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
}
