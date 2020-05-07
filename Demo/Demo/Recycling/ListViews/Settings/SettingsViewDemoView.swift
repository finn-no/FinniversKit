//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

// MARK: - SettingsViewDemoView
class SettingsViewDemoView: UIView {

     private var sections = [
        SettingsSection(
            title: "Varslinger",
            rows: [
                .toggle(SettingsToggleViewModel(title: "Prisnedgang på favoritter - Torget", isOn: true))
            ],
            footerTitle: "FINN varsler deg når priser på en av dine favoritter på Torget blir satt ned i pris."
        ),
        SettingsSection(
            title: "Personvern",
            rows: [
                .consent(.init(title: "Få nyhetsbrev fra FINN", status: "Av")),
                .consent(.init(title: "Personlig tilpasset FINN", status: "På")),
                .consent(.init(title: "Motta viktig informasjon fra FINN", status: "På")),
                .text(.init(title: "Smart reklame")),
                .text(.init(title: "Last ned dine data")),
                .text(.init(title: "Slett meg som bruker"))
            ],
            footerTitle: nil
        )
    ]

    private lazy var settingsView: SettingsView = {
        let settingsView = SettingsView(withAutoLayout: true)
        settingsView.dataSource = self
        settingsView.delegate = self
        settingsView.versionText = "FinniversKit Demo"
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
        return sections[section].rows.count
    }

    func settingsView(_ settingsView: SettingsView, rowForCellAt indexPath: IndexPath) -> SettingsRow {
        return sections[indexPath.section].rows[indexPath.item]
    }
}

extension SettingsViewDemoView: SettingsViewDelegate {
    func settingsView(_ settingsView: SettingsView, didSelectModelAt indexPath: IndexPath) {
        let model = sections[indexPath.section].rows[indexPath.item]
        print("Did selector model:\n\t- \(model)")
    }

    func settingsView(_ settingsView: SettingsView, didToggleSettingAt indexPath: IndexPath, isOn: Bool) {
        let section = indexPath.section
        let item = indexPath.item

        switch sections[section].rows[item] {
        case .toggle(var model):
            model.isOn = isOn
            sections[section].rows[item] = .toggle(model)
            print("Did toggle settings for model:\n\t- \(model)")
        default:
            break
        }
    }

    func settingsView(_ settingsView: SettingsView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    func settingsView(_ settingsView: SettingsView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footerTitle
    }
}

// MARK: - Private Methods
private extension SettingsViewDemoView {
    func setup() {
        addSubview(settingsView)
        settingsView.fillInSuperview()
    }
}
