//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import Bootstrap

private struct ViewModel: BasicTableViewCellViewModel {
    var title: String
    var subtitle: String?
    var detailText: String?
    var hasChevron: Bool
}

class BasicCellVariationsDemoView: UIView {
    private let viewModels = [
        ViewModel(title: "Hagemøbler", subtitle: nil, detailText: nil, hasChevron: false),
        ViewModel(title: "Kattepuser", subtitle: "Fin-fine kattunger", detailText: nil, hasChevron: true),
        ViewModel(title: "Mac Mini Pro", subtitle: "En noe kraftigere Mac Mini", detailText: nil, hasChevron: true),
        ViewModel(title: "Mac Pro Mini", subtitle: nil, detailText: nil, hasChevron: false),
        ViewModel(title: "Mac Pro Max", subtitle: nil, detailText: nil, hasChevron: false),
        ViewModel(title: "Kristiansand", subtitle: nil, detailText: "4 352", hasChevron: false),
        ViewModel(title: "Oslo", subtitle: nil, detailText: "46 347", hasChevron: true)
    ]

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 48
        tableView.register(BasicTableViewCell.self)
        tableView.separatorInset = .leadingInset(frame.width)
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BasicCellVariationsDemoView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == (viewModels.count - 1)
        if isLastCell {
            cell.separatorInset = .leadingInset(frame.width)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension BasicCellVariationsDemoView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(BasicTableViewCell.self, for: indexPath)
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
}
