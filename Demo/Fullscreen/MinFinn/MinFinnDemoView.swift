//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

private struct ProfileItem: MinFinnProfileCellModel {
    let image: UIImage?
    let title: String
    let subtitle: String?
    let showBadge: Bool
}

private struct IconItem: MinFinnIconCellModel {
    let icon: UIImage?
    let title: String
}

private struct Item: MinFinnCellModel {
    let title: String
    let hasChevron: Bool
}

private struct Section {
    let items: [MinFinnCellModel]
}

class MinFinnDemoView: UIView {

    private lazy var sections = [
        Section(items: [
            ProfileItem(image: nil, title: "Ola Nordmann", subtitle: "ola.nordmann@finn.no", showBadge: true)
        ]),
        Section(items: [
            IconItem(icon: UIImage(named: "favorites"), title: "Favoritter"),
            IconItem(icon: UIImage(named: "savedSearches"), title: "Lagrede Søk"),
            IconItem(icon: UIImage(named: "ratings"), title: "Vurderinger")
        ]),
        Section(items: [
            Item(title: "Personvernerklæring", hasChevron: true),
            Item(title: "Instillinger", hasChevron: true),
            Item(title: "Kundeservice", hasChevron: false),
            Item(title: "Logg ut", hasChevron: false),
        ])
    ]

    private lazy var minFinnView: MinFinnView = {
        let view = MinFinnView(withAutoLayout: true)
        view.dataSource = self
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(minFinnView)
        minFinnView.fillInSuperview()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MinFinnDemoView: MinFinnViewDataSource {
    func numberOfSections(in view: MinFinnView) -> Int {
        sections.count
    }

    func minFinnView(_ view: MinFinnView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }

    func minFinnView(_ view: MinFinnView, modelForRowAt indexPath: IndexPath) -> MinFinnCellModel {
        sections[indexPath.section].items[indexPath.item]
    }
}
