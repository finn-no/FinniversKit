//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

// MARK: - Models
private struct SettingsToggleItem: SettingsViewToggleCellModel {
    let title: String
    var isOn: Bool
}

private struct SettingsConsentItem: SettingsViewConsentCellModel {
    let title: String
    var status: String
}

private struct SettingsItem: SettingsViewCellModel {
    let title: String
}

private struct SettingsSection {
    let title: String
    let items: [SettingsViewCellModel]
    let footerTitle: String?
    let footerView: UIView?
}

// MARK: - SettingsViewDemoView
class SettingsViewDemoView: UIView {

     private var sections = [
           SettingsSection(
               title: "Varslinger",
               items: [
                   SettingsToggleItem(title: "Prisnedgang på favoritter - Torget", isOn: true)
               ],
               footerTitle: "FINN varsler deg når priser på en av dine favoritter på Torget blir satt ned i pris.",
               footerView: nil
           ),
           SettingsSection(
               title: "Personvern",
               items: [
                   SettingsConsentItem(title: "Få nyhetsbrev fra FINN", status: "Av"),
                   SettingsConsentItem(title: "Personlin tilpasset FINN", status: "På"),
                   SettingsConsentItem(title: "Motta viktig informasjon fra FINN", status: "På"),
                   SettingsItem(title: "Smart reklame"),
                   SettingsItem(title: "Last ned dine data"),
                   SettingsItem(title: "Slett meg som bruker")
               ],
               footerTitle: nil,
               footerView: nil
           )
       ]

    private lazy var settingsView: SettingsView = {
        let settingsView = SettingsView(withAutoLayout: true)
        settingsView.dataSource = self
        settingsView.delegate = self
        return settingsView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsViewDemoView: SettingsViewDataSource {
    func numberOfSections(in settingsView: SettingsView) -> Int {
        return sections.count
    }

    func settingsView(_ settingsView: SettingsView, numberOfItemsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func settingsView(_ settingsView: SettingsView, modelForItemAt indexPath: IndexPath) -> SettingsViewCellModel {
        return sections[indexPath.section].items[indexPath.item]
    }
}

extension SettingsViewDemoView: SettingsViewDelegate {
    func settingsView(_ settingsView: SettingsView, didSelectModelAt indexPath: IndexPath) {
        let model = sections[indexPath.section].items[indexPath.item]
        print("Did selector model:\n\t- \(model)")
    }

    func settingsView(_ settingsView: SettingsView, didToggleSettingFor model: SettingsViewToggleCellModel, at indexPath: IndexPath) {
        print("Did toggle settings for model:\n\t- \(model)")
    }

    func settingsView(_ settingsView: SettingsView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    func settingsView(_ settingsView: SettingsView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footerTitle
    }

    func settingsView(_ settingsView: SettingsView, viewForFooterInSection section: Int) -> UIView? {
        return sections[section].footerView
    }
}

// MARK: - Private Methods
private extension SettingsViewDemoView {
    func setup() {
        addSubview(settingsView)
        settingsView.fillInSuperview()
    }
}
