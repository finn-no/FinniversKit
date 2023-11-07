//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit
import DemoKit
import struct SwiftUI.Color

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

private struct SettingsIconItem: SettingsViewIconCellModel {
    var title: String
    var icon: (image: UIImage, tintColor: Color?)
}

// MARK: - SettingsViewDemoView
class SettingsViewDemoView: UIView, Demoable {

     private var sections = [
        SettingsSection(
            header: .plain(title: "Varslinger"),
            items: [
                SettingsToggleItem(title: "Prisnedgang på favoritter - Torget", isOn: true)
            ],
            footerTitle: "FINN varsler deg når priser på en av dine favoritter på Torget blir satt ned i pris."
        ),
        SettingsSection(
            header: .plain(title: "Personvern"),
            items: [
                SettingsConsentItem(title: "Få nyhetsbrev fra FINN", status: "Av"),
                SettingsConsentItem(title: "Personlig tilpasset FINN", status: "På"),
                SettingsConsentItem(title: "Motta viktig informasjon fra FINN", status: "På"),
                SettingsItem(title: "Smart reklame"),
                SettingsItem(title: "Last ned dine data"),
                SettingsItem(title: "Slett meg som bruker"),
                SettingsIconItem(title: "Personvernerklæring", icon: (image: .init(systemName: "square.and.arrow.up")!, tintColor: .textSecondary)) // swiftlint:disable:this force_unwrapping
            ],
            footerTitle: nil
        )
    ]

    private lazy var settingsView: SettingsView = {
        let settingsView = SettingsView(viewTitle: nil, versionText: "FinniversKit Demo", logoImage: .brandLogoSimple)
        settingsView.translatesAutoresizingMaskIntoConstraints = false
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

    func settingsView(_ settingsView: SettingsView, didToggleSettingAt indexPath: IndexPath, isOn: Bool) {
        let section = indexPath.section
        let item = indexPath.item

        guard var model = sections[section].items[item] as? SettingsToggleItem else {
            return
        }

        model.isOn = isOn
        sections[section].items[item] = model

        print("Did toggle settings for model:\n\t- \(model)")
    }

    func settingsView(_ settingsView: FinniversKit.SettingsView, titleForHeaderInSection section: Int) -> FinniversKit.SettingsHeaderType? {
        return sections[section].header
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
