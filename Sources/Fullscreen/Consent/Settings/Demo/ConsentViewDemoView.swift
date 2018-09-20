
//
//  Copyright © 2018 FINN AS. All rights reserved.
//
import FinniversKit

class ConsentViewDemoView: UIView {

    let sections = [
        Section(title: "Varslinger", items: [ConsentViewCellModel(title: "Meldinger", state: nil, tag: .detail),
                                             ConsentViewCellModel(title: "Lagrede Søk", state: nil, tag: .detail),
                                             ConsentViewCellModel(title: "Prisnedgang på Torget", state: nil, tag: .detail)]),
        Section(title: "Personvern", items: [ConsentViewCellModel(title: "Få nyhetsbrev fra FINN", state: .off, tag: .detail),
                                             ConsentViewCellModel(title: "Personlig tilpasset FINN", state: .on, tag: .detail),
                                             ConsentViewCellModel(title: "Motta viktig informasjon fra FINN", state: .on, tag: .detail),
                                             ConsentViewCellModel(title: "Smart reklame", state: nil, tag: .action),
                                             ConsentViewCellModel(title: "Last ned dine data", state: nil, tag: .action),
                                             ConsentViewCellModel(title: "Slett meg som bruker", state: nil, tag: .action)])]

    lazy var consentView: ConsentView = {
        let view = ConsentView(frame: .zero, style: .grouped)
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

extension ConsentViewDemoView: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ConsentViewCell.identifier, for: indexPath) as? ConsentViewCell else { return UITableViewCell() }
        cell.model = sections[indexPath.section].items[indexPath.row]
        if indexPath.row == sections[indexPath.section].items.count - 1 { cell.removeHairLine() }
        return cell
    }
}

extension ConsentViewDemoView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return consentView.headerView(for: section, with: sections[section].title)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select")
    }
}

private extension ConsentViewDemoView {

    func setupSubviews() {
        addSubview(consentView)
        let constraints = [
            consentView.leadingAnchor.constraint(equalTo: leadingAnchor),
            consentView.topAnchor.constraint(equalTo: topAnchor),
            consentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            consentView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
