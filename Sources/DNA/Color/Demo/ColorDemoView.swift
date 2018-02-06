//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Munch
import UIKit

struct ColorItem {
    let color: UIColor
    let title: String
}

public class ColorDemoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .none
        view.rowHeight = 60
        return view
    }()

    lazy var items: [ColorItem] = {
        return [
            ColorItem(color: .ice, title: "ice"),
            ColorItem(color: .milk, title: "milk"),
            ColorItem(color: .licorice, title: "licorice"),
            ColorItem(color: .primaryBlue, title: "primaryBlue"),
            ColorItem(color: .secondaryBlue, title: "secondaryBlue"),
            ColorItem(color: .stone, title: "stone"),
            ColorItem(color: .sardine, title: "sardine"),
            ColorItem(color: .salmon, title: "salmon"),
            ColorItem(color: .mint, title: "mint"),
            ColorItem(color: .toothPaste, title: "toothPaste"),
            ColorItem(color: .banana, title: "banana"),
            ColorItem(color: .cherry, title: "cherry"),
            ColorItem(color: .watermelon, title: "watermelon"),
            ColorItem(color: .pea, title: "pea"),
        ]
    }()

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(tableView)
        tableView.dataSource = self
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        tableView.register(UITableViewCell.self)
    }
}

extension ColorDemoView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UITableViewCell.self, for: indexPath)
        let item = items[indexPath.row]
        cell.backgroundColor = item.color
        cell.textLabel?.text = item.title.capitalized

        cell.textLabel?.font = UIFont.title4
        cell.textLabel?.textColor = UIColor.black
        cell.selectionStyle = .none

        return cell
    }
}
