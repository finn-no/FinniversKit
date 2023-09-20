import DemoKit
import FinniversKit
import SwiftUI

final class HostingContentConfigurationCell: UITableViewCell {}

class HostingContentConfigurationCellDemoView: UIView, Demoable {
    var dismissKind: DismissKind { .button }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.dataSource = self
        tableView.register(HostingContentConfigurationCell.self)
        tableView.separatorInset = .leadingInset(frame.width)
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

// MARK: - UITableViewDataSource

extension HostingContentConfigurationCellDemoView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeue(HostingContentConfigurationCell.self, for: indexPath)
        cell.contentConfiguration = HostingContentConfiguration {
            if index.isMultiple(of: 2) {
                HStack {
                    Text("Cell \(index)")
                    Text("Cell \(index)")
                    Text("Cell \(index)")
                }
            } else {
                VStack {
                    Text("Cell \(index)")
                    Text("Cell \(index)")
                    Text("Cell \(index)")
                }
            }
        }
        return cell
    }
}
