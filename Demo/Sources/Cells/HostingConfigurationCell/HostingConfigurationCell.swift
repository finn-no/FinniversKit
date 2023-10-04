import DemoKit
import FinniversKit
import SwiftUI

final class HostingContentConfigurationCell: UITableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentConfiguration = nil
    }
}

final class HostingContentConfigurationCellDemoViewController: UIViewController, Demoable {
    var dismissKind: DismissKind { .button }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.dataSource = self
        tableView.register(HostingContentConfigurationCell.self)
        tableView.separatorInset = .leadingInset(view.bounds.width)
        return tableView
    }()

    private lazy var countLabel = {
        let label = Label(style: .body, withAutoLayout: true)
        label.textAlignment = .center
        label.backgroundColor = .bgPrimary
        return label
    }()

    init() {
        super.init(nibName: nil, bundle: nil)
        setup()
    }

    private func setup() {
        let contentStack = UIStackView(axis: .vertical, withAutoLayout: true)
        contentStack.addArrangedSubviews([tableView, countLabel])
        view.addSubview(contentStack)
        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: view.topAnchor),
            contentStack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UITableViewDataSource

extension HostingContentConfigurationCellDemoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1000
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell = tableView.dequeue(HostingContentConfigurationCell.self, for: indexPath)
        cell.contentConfiguration = HostingContentConfiguration {
            VStack {
                Text("Cell \(index)")
                Text("Cell \(index)")
                Text("Cell \(index)")
            }
        }

        countLabel.text = "Child controllers: \(children.count)"

        return cell
    }
}
