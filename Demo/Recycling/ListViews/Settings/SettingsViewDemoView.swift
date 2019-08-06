//
//  Copyright © 2018 FINN AS. All rights reserved.
//
import FinniversKit

struct SettingsSection {
    var title: String
    var items: [SettingsViewCellModel]
}

struct SettingsItem: SettingsViewCellModel {
    let title: String
    var status: String?

    init(title: String, status: String? = nil) {
        self.title = title
        self.status = status
    }
}

class SettingsViewDemoView: UIView {
    private let sections = [SettingsSection(title: "Varslinger", items: [SettingsItem(title: "Prisnedgang på torget")]),

                            SettingsSection(title: "Personvern", items: [SettingsItem(title: "Få nyhetsbrev fra FINN", status: "Av"),
                                                                         SettingsItem(title: "Personlin tilpasset FINN", status: "På"),
                                                                         SettingsItem(title: "Motta viktig informasjon fra FINN", status: "På"),
                                                                         SettingsItem(title: "Smart reklame"),
                                                                         SettingsItem(title: "Last ned dine data"),
                                                                         SettingsItem(title: "Slett meg som bruker")])]

    private lazy var settingsView: SettingsView = {
        let view = SettingsView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingsViewDemoView: SettingsViewDataSource {
    func numberOfSections(in settingsView: SettingsView) -> Int {
        return sections.count
    }

    func settingsView(_ settingsView: SettingsView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func settingsView(_ settingsView: SettingsView, modelForItemAt indexPath: IndexPath) -> SettingsViewCellModel {
        return sections[indexPath.section].items[indexPath.row]
    }
}

extension SettingsViewDemoView: SettingsViewDelegate {
    func settingsView(_ settingsView: SettingsView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].title
    }

    func settingsView(_ settingsView: SettingsView, didSelectRowAt indexPath: IndexPath) {
        print("did select")
    }

    func settingsView(_ settingsView: SettingsView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

private extension SettingsViewDemoView {
    func setup() {
        addSubview(settingsView)
        settingsView.fillInSuperview()
    }
}
