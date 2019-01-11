//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

private struct ViewModel: IconTitleTableViewCellViewModel {
    var title: String
    let subtitle: String? = nil
    let detailText: String? = nil
    var icon: UIImage?
    var iconTintColor: UIColor?
    var hasChevron: Bool
}

class IconTitleCellDemoView: UIView {
    private var viewModels = [
        ViewModel(title: "Favoritter", icon: UIImage(named: .favouriteAdded), iconTintColor: .watermelon, hasChevron: true),
        ViewModel(title: "Lagrede søk", icon: UIImage(named: .search), iconTintColor: .licorice, hasChevron: false),
        ViewModel(title: "Varslingsinnstillinger", icon: nil, iconTintColor: nil, hasChevron: true),
        ViewModel(title: "Personvernerklæring", icon: nil, iconTintColor: nil, hasChevron: true),
        ViewModel(title: "Innstillinger for personvern", icon: nil, iconTintColor: nil, hasChevron: false),
        ViewModel(title: "Kundeservice", icon: nil, iconTintColor: nil, hasChevron: false),
        ViewModel(title: "Logg ut", icon: nil, iconTintColor: nil, hasChevron: false)
    ]

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.dataSource = self
        tableView.rowHeight = 44
        tableView.register(IconTitleTableViewCell.self)
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

extension IconTitleCellDemoView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(IconTitleTableViewCell.self, for: indexPath)
        cell.configure(with: viewModels[indexPath.row])
        cell.separatorInset = .leadingInset(frame.width)
        return cell
    }
}
