//
//  Copyright © 2018 FINN AS. All rights reserved.
//
import UIKit

public protocol SettingsViewDataSource: AnyObject {
    func numberOfSections(in settingsView: SettingsView) -> Int
    func settingsView(_ settingsView: SettingsView, numberOfRowsInSection section: Int) -> Int
    func settingsView(_ settingsView: SettingsView, modelForItemAt indexPath: IndexPath) -> SettingsViewCellModel
}

public protocol SettingsViewDelegate: AnyObject {
    func settingsView(_ settingsView: SettingsView, titleForHeaderInSection section: Int) -> String?
    func settingsView(_ settingsView: SettingsView, didSelectRowAt indexPath: IndexPath)
    func settingsView(_ settingsView: SettingsView, viewForFooterInSection section: Int) -> UIView?
}

public class SettingsView: UIView {
    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = UIEdgeInsets(top: .mediumLargeSpacing, leading: 0, bottom: 0, trailing: 0)
        view.backgroundColor = .marble
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        view.register(SettingsViewCell.self)
        view.register(SettingsViewSectionHeaderView.self)
        return view
    }()

    public weak var dataSource: SettingsViewDataSource?
    public weak var delegate: SettingsViewDelegate?

    public var contentInset: UIEdgeInsets {
        get {
            return tableView.contentInset
        }
        set {
            tableView.contentInset = newValue
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func reloadData() {
        tableView.reloadData()
    }

    public func cellForRow(at indexPath: IndexPath) -> UITableViewCell? {
        return tableView.cellForRow(at: indexPath)
    }
}

private extension SettingsView {
    func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
    }
}

extension SettingsView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfSections(in: self) ?? 0
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.settingsView(self, numberOfRowsInSection: section) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SettingsViewCell.self, for: indexPath)
        let model = dataSource?.settingsView(self, modelForItemAt: indexPath)

        guard let numberOfItems = dataSource?.settingsView(self, numberOfRowsInSection: indexPath.section) else {
            fatalError("There must be items to populate the cell")
        }
        let isLastItem = indexPath.row == numberOfItems - 1
        cell.configure(with: model, isLastItem: isLastItem)

        return cell
    }
}

extension SettingsView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeue(SettingsViewSectionHeaderView.self)
        headerView.title = delegate?.settingsView(self, titleForHeaderInSection: section)
        return headerView
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.settingsView(self, didSelectRowAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return delegate?.settingsView(self, viewForFooterInSection: section)
    }
}
