
//
//  Copyright © 2018 FINN AS. All rights reserved.
//
import FinniversKit

class ConsentViewDemoView: UIView {

    let model = ConsentViewCellModel(detailModel: DetailModel(definition: Definition(text: ""), purpose: Purpose(heading: "", description: "")), state: nil, tag: .detail)
    
    let sections = [Section(title: "Varslinger", items: [ConsentViewCellModel(detailModel: DetailModel(definition: Definition(text: ""), purpose: Purpose(heading: "Meldinger", description: "")), state: nil, tag: .detail),
                                                         ConsentViewCellModel(detailModel: DetailModel(definition: Definition(text: ""), purpose: Purpose(heading: "Varslinger", description: "")), state: nil, tag: .detail),
                                                         ConsentViewCellModel(detailModel: DetailModel(definition: Definition(text: ""), purpose: Purpose(heading: "Prisnedgang på torget", description: "")), state: nil, tag: .detail)]),
                    Section(title: "Personvern", items: [ConsentViewCellModel(detailModel: DetailModel(definition: Definition(text: ""), purpose: Purpose(heading: "Få nyhetsbrev fra FINN", description: "")), state: nil, tag: .detail),
                                                         ConsentViewCellModel(detailModel: DetailModel(definition: Definition(text: ""), purpose: Purpose(heading: "Personlig tilpasset FINN", description: "")), state: nil, tag: .detail),
                                                         ConsentViewCellModel(detailModel: DetailModel(definition: Definition(text: ""), purpose: Purpose(heading: "Motta viktig informasjon fra FINN", description: "")), state: nil, tag: .detail),
                                                         ConsentViewCellModel(detailModel: DetailModel(definition: Definition(text: ""), purpose: Purpose(heading: "Smart reklame", description: "")), state: nil, tag: .detail),
                                                         ConsentViewCellModel(detailModel: DetailModel(definition: Definition(text: ""), purpose: Purpose(heading: "Last ned dine data", description: "")), state: nil, tag: .detail),
                                                         ConsentViewCellModel(detailModel: DetailModel(definition: Definition(text: ""), purpose: Purpose(heading: "Slett meg som bruker", description: "")), state: nil, tag: .detail)])]

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
