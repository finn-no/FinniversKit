//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

// MARK: - Protocols
public protocol SettingsViewDataSource: AnyObject {
    func numberOfSections(in settingsView: SettingsView) -> Int
    func settingsView(_ settingsView: SettingsView, numberOfItemsInSection section: Int) -> Int
    func settingsView(_ settingsView: SettingsView, modelForItemAt indexPath: IndexPath) -> SettingsViewCellModel
}

public protocol SettingsViewDelegate: AnyObject {
    func settingsView(_ settingsView: SettingsView, didSelectModelAt indexPath: IndexPath)
    func settingsView(_ settingsView: SettingsView, didToggleSettingFor model: SettingsViewToggleCellModel, at indexPath: IndexPath)
    func settingsView(_ settingsView: SettingsView, titleForHeaderInSection section: Int) -> String?
    func settingsView(_ settingsView: SettingsView, titleForFooterInSection section: Int) -> String?
}

public class SettingsView: UIView {

    // MARK: - Public Properties

    public weak var dataSource: SettingsViewDataSource?
    public weak var delegate: SettingsViewDelegate?

    // MARK: - Private Properties

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = .bgTertiary
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(SettingsViewCell.self)
        tableView.register(SettingsViewToggleCell.self)
        tableView.register(SettingsViewConsentCell.self)
        tableView.register(SettingsSectionHeaderView.self)
        tableView.register(SettingsSectionFooterView.self)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public methods
public extension SettingsView {
    var footerView: UIView? {
        get { tableView.tableFooterView }
        set { tableView.tableFooterView = newValue }
    }

    func reloadRows(at indexPaths: [IndexPath], animated: Bool = true) {
        tableView.reloadRows(at: indexPaths, with: animated ? .automatic : .none)
    }

    func cellForRow(at indexPath: IndexPath) -> UITableViewCell? {
        return tableView.cellForRow(at: indexPath)
    }

    var indexPathForSelectedRow: IndexPath? {
        return tableView.indexPathForSelectedRow
    }
}

// MARK: - SettingsViewToggleCellDelegate
extension SettingsView: SettingsViewToggleCellDelegate {
    func settingsViewToggleCell(_ cell: SettingsViewToggleCell, didToggleSettingFor model: SettingsViewToggleCellModel) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        delegate?.settingsView(self, didToggleSettingFor: model, at: indexPath)
    }
}

// MARK: - TableViewDataSource
extension SettingsView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfSections(in: self) ?? 0
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.settingsView(self, numberOfItemsInSection: section) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = dataSource?.settingsView(self, modelForItemAt: indexPath)
        let isLastItem = indexPath.item == tableView.numberOfRows(inSection: indexPath.section) - 1

        switch model {
        case let toggleModel as SettingsViewToggleCellModel:
            let cell = tableView.dequeue(SettingsViewToggleCell.self, for: indexPath)
            cell.configure(with: toggleModel, isLastItem: isLastItem)
            cell.delegate = self
            return cell

        case let consentModel as SettingsViewConsentCellModel:
            let cell = tableView.dequeue(SettingsViewConsentCell.self, for: indexPath)
            cell.configure(with: consentModel, isLastItem: isLastItem)
            return cell

        default:
            let cell = tableView.dequeue(SettingsViewCell.self, for: indexPath)
            cell.configure(with: model, isLastItem: isLastItem)
            return cell
        }
    }
}

// MARK: - TableViewDelegate
extension SettingsView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.settingsView(self, didSelectModelAt: indexPath)
    }

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let title = delegate?.settingsView(self, titleForHeaderInSection: section) else {
            return nil
        }

        let headerView = tableView.dequeue(SettingsSectionHeaderView.self)
        headerView.configure(with: title.uppercased())

        return headerView
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let footerTitle = delegate?.settingsView(self, titleForFooterInSection: section) {
            let footerView = tableView.dequeue(SettingsSectionFooterView.self)
            footerView.configure(with: footerTitle)

            return footerView
        }

        return nil
    }

    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }

    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if delegate?.settingsView(self, titleForFooterInSection: section) != nil {
            return 48
        } else {
            return 0
        }
    }
}

// MARK: - Private Methods
private extension SettingsView {
    func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
    }
}
