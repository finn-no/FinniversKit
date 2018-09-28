
//
//  Copyright © 2018 FINN AS. All rights reserved.
//
import FinniversKit

struct Section {
    var title: String
    var items: [ConsentViewCellModel]
}

class ConsentViewDemoView: UIView {
    
    private let sections = [Section(title: "Varslinger", items: [ConsentViewCellModel(title: "Prisnedgang på torget", hairLine: false)]),

                            Section(title: "Personvern", items: [ConsentViewCellModel(title: "Få nyhetsbrev fra FINN", state: .withdrawn),
                                                                 ConsentViewCellModel(title: "Personlin tilpasset FINN", state: .accepted),
                                                                 ConsentViewCellModel(title: "Motta viktig informasjon fra FINN", state: .accepted),
                                                                 ConsentViewCellModel(title: "Smart reklame"),
                                                                 ConsentViewCellModel(title: "Last ned dine data"),
                                                                 ConsentViewCellModel(title: "Slett meg som bruker", hairLine: false)])]

    private lazy var consentView: ConsentView = {
        let view = ConsentView(frame: .zero, style: .grouped)
        view.contentInset = UIEdgeInsets(top: 16, leading: 0, bottom: 0, trailing: 0)
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
        let cell = tableView.dequeue(ConsentViewCell.self, for: indexPath)
        cell.model = sections[indexPath.section].items[indexPath.row]
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
        consentView.fillInSuperview()
    }
}
