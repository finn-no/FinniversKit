
//
//  Copyright © 2018 FINN AS. All rights reserved.
//
import FinniversKit

struct Section {
    var title: String
    var items: [SettingsViewCellModel]
}

class SettingsViewDemoView: UIView {
    
    private let sections = [Section(title: "Varslinger", items: [SettingsViewCellModel(title: "Prisnedgang på torget", hairline: false)]),

                            Section(title: "Personvern", items: [SettingsViewCellModel(title: "Få nyhetsbrev fra FINN", status: "Av"),
                                                                 SettingsViewCellModel(title: "Personlin tilpasset FINN", status: "På"),
                                                                 SettingsViewCellModel(title: "Motta viktig informasjon fra FINN", status: "På"),
                                                                 SettingsViewCellModel(title: "Smart reklame"),
                                                                 SettingsViewCellModel(title: "Last ned dine data"),
                                                                 SettingsViewCellModel(title: "Slett meg som bruker", hairline: false)])]

    private lazy var consentView: SettingsView = {
        let view = SettingsView(frame: .zero, style: .grouped)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentInset = UIEdgeInsets(top: .mediumLargeSpacing, leading: 0, bottom: 0, trailing: 0)
        view.dataSource = self
        view.delegate = self
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsViewDemoView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(SettingsViewCell.self, for: indexPath)
        cell.model = sections[indexPath.section].items[indexPath.row]
        return cell
    }
}

extension SettingsViewDemoView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return consentView.headerView(for: section, with: sections[section].title)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select")
    }
}

private extension SettingsViewDemoView {

    func setupSubviews() {
        addSubview(consentView)
        consentView.fillInSuperview()
    }
}
