//
//  Copyright © 2018 FINN AS. All rights reserved.
//
import UIKit

public protocol SettingsViewDataSource: class {
    func numberOfSections(in settingsView: SettingsView) -> Int
    func settingsView(_ settingsView: SettingsView, numberOfRowsInSection section: Int) -> Int
    func settingsView(_ settingsView: SettingsView, modelForItemAt indexPath: IndexPath) -> SettingsViewCellModel
}

public protocol SettingsViewDelegate: class {
    func settingsView(_ settingsView: SettingsView, titleForHeaderInSection section: Int) -> String?
    func settingsView(_ settingsView: SettingsView, didSelectRowAt indexPath: IndexPath)
}

public class SettingsView: UIView {

    private lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = UIEdgeInsets(top: .mediumLargeSpacing, leading: 0, bottom: 0, trailing: 0)
        view.backgroundColor = .milk
        view.separatorStyle = .none
        view.dataSource = self
        view.delegate = self
        view.register(SettingsViewCell.self)
        return view
    }()

    public weak var dataSource: SettingsViewDataSource?
    public weak var delegate: SettingsViewDelegate?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension SettingsView {
    func setupSubViews() {
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
        cell.model = dataSource?.settingsView(self, modelForItemAt: indexPath)
        return cell
    }
}

extension SettingsView: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: .zero)

        let label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = delegate?.settingsView(self, titleForHeaderInSection: section)

        view.addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .mediumLargeSpacing),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: .mediumSpacing),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.mediumLargeSpacing),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -.mediumSpacing),
        ])

        return view
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.settingsView(self, didSelectRowAt: indexPath)
    }
}
