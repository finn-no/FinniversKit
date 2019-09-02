//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

private struct ViewModel: IconTitleTableViewCellViewModel {
    var title: String
    let subtitle: String?
    let detailText: String?
    var icon: UIImage?
    var iconTintColor: UIColor?
    var hasChevron: Bool

    init(
        title: String, subtitle: String? = nil, detailText: String? = nil,
        icon: UIImage? = nil, iconTintColor: UIColor? = nil, hasChevron: Bool = false) {
        self.title = title
        self.subtitle = subtitle
        self.detailText = detailText
        self.icon = icon
        self.iconTintColor = iconTintColor
        self.hasChevron = hasChevron
    }
}

class IconTitleCellDemoView: UIView {
    private var viewModels = [
        ViewModel(title: "Favoritter", icon: UIImage(named: .favouriteAdded), iconTintColor: .licorice, hasChevron: true),
        ViewModel(title: "Lagrede søk", icon: UIImage(named: .search), iconTintColor: .licorice),
        ViewModel(title: "Varslingsinnstillinger", hasChevron: true),
        ViewModel(title: "Personvernerklæring", hasChevron: true),
        ViewModel(title: "Innstillinger for personvern"),
        ViewModel(title: "Kundeservice"),
        ViewModel(title: "Logg ut")
    ]

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.dataSource = self
        tableView.rowHeight = 48
        tableView.register(IconTitleTableViewCell.self)
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
        return cell
    }
}
