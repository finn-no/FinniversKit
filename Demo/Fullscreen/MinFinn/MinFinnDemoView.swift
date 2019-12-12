//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

private struct ProfileItem: MinFinnProfileCellModel {
    let profileImage: UIImage?
    let profileImageUrl: URL?
    let displayName: String
    let subtitle: String
    let isVerified: Bool
    weak var delegate: MinFinnProfileCellDelegate?
}

private struct VerifyItem: MinFinnVerifyCellModel {
    let title: String
    let text: String
    let primaryButtonTitle: String
    let secondaryButtonTitle: String
    weak var delegate: MinFinnVerifyCellDelegate?
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
            ProfileItem(profileImage: nil, profileImageUrl: nil, displayName: "Ola Nordmann", subtitle: "ola.nordmann@finn.no", isVerified: false, delegate: self),
            VerifyItem(title: "Vis andre at du er trygg", text: "Hvis du godkjenner profilen din med BankID oppleves du som en tryggere person å handle med.", primaryButtonTitle: "Kom i gang", secondaryButtonTitle: "Les mer om godkjenning", delegate: self)
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
        view.delegate = self
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

extension MinFinnDemoView: MinFinnViewDelegate {
    func minFinnView(_ view: MinFinnView, didSelectModelAt indexPath: IndexPath) {
        let model = sections[indexPath.section].items[indexPath.item]
        print("Did select model: \n\t- \(model)")
    }
}

extension MinFinnDemoView: MinFinnProfileCellDelegate {
    func minFinnProfileCell(_ cell: MinFinnProfileCell, loadImageAt url: URL, completionHandler: @escaping (UIImage?) -> Void) {
        print("Load image")
    }
}

extension MinFinnDemoView: MinFinnVerifyCellDelegate {
    func minFinnVerifiyCell(_ cell: MinFinnVerifyCell, didSelect action: MinFinnVerifyCell.Action) {
        switch action {
        case .primary: print("Primary button tapped")
        case .secondary: print("Secondary button tapped")
        }
    }
}
