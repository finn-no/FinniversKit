//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

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
        view.rowHeight = 18
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

            ColorItem(color: .bgPrimary, title: "bgPrimary"),
            ColorItem(color: .bgSecondary, title: "bgSecondary"),
            ColorItem(color: .bgTertiary, title: "bgTertiary"),
            ColorItem(color: .bgAlert, title: "bgAlert"),
            ColorItem(color: .bgSuccess, title: "bgSuccess"),
            ColorItem(color: .bgCritical, title: "bgCritical"),

            ColorItem(color: .btnPrimary, title: "btnPrimary"),
            ColorItem(color: .btnDisabled, title: "btnDisabled"),
            ColorItem(color: .btnCritical, title: "btnCritical"),
            ColorItem(color: .textPrimary, title: "textPrimary"),
            ColorItem(color: .textSecondary, title: "textSecondary"),
            ColorItem(color: .textTertiary, title: "textTertiary"),
            ColorItem(color: .textAction, title: "textAction"),
            ColorItem(color: .textDisabled, title: "textDisabled"),
            ColorItem(color: .textCritical, title: "textCritical"),
            ColorItem(color: .accentSecondaryBlue, title: "accentSecondaryBlue"),
            ColorItem(color: .accentPea, title: "accentPea"),
            ColorItem(color: .accentToothpaste, title: "accentToothpaste"),
            ColorItem(color: .textCTADisabled, title: "textCTADisabled"),
            ColorItem(color: .textToast, title: "textToast"),
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
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
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
        let title = item.title.capitalizingFirstLetter + "  "
        let attributedTitle = NSMutableAttributedString(string: title)
        attributedTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.licorice, range: NSRange(location: 0, length: title.count))
        let whiteTitle = NSMutableAttributedString(string: title)
        whiteTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.milk, range: NSRange(location: 0, length: title.count))
        attributedTitle.append(whiteTitle)
        cell.textLabel?.attributedText = attributedTitle
        cell.textLabel?.font = UIFont.detail
        cell.selectionStyle = .none

        return cell
    }
}
