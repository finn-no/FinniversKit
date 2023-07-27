//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

struct ColorItem {
    let color: UIColor
    let title: String
}

class ColorDemoView: UIView, Demoable {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    lazy var tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.separatorStyle = .none
        view.rowHeight = 21
        return view
    }()

    lazy var items: [ColorItem] = {
        return [
            ColorItem(color: .accentPea, title: "accentPea"),
            ColorItem(color: .accentPrimaryBlue, title: "accentPrimaryBlue"),
            ColorItem(color: .accentSecondaryBlue, title: "accentSecondaryBlue"),
            ColorItem(color: .accentToothpaste, title: "accentToothpaste"),
            ColorItem(color: .bgAlert, title: "bgAlert"),
            ColorItem(color: .bgBottomSheet, title: "bgBottomSheet"),
            ColorItem(color: .bgCritical, title: "bgCritical"),
            ColorItem(color: .bgInfo, title: "bgInfo"),
            ColorItem(color: .bgInfoHeader, title: "bgInfoHeader"),
            ColorItem(color: .bgPrimary, title: "bgPrimary"),
            ColorItem(color: .bgQuaternary, title: "bgQuaternary"),
            ColorItem(color: .bgSecondary, title: "bgSecondary"),
            ColorItem(color: .bgSuccess, title: "bgSuccess"),
            ColorItem(color: .bgTertiary, title: "bgTertiary"),
            ColorItem(color: .borderDefault, title: "borderDefault"),
            ColorItem(color: .btnAction, title: "btnAction"),
            ColorItem(color: .btnCritical, title: "btnCritical"),
            ColorItem(color: .btnDisabled, title: "btnDisabled"),
            ColorItem(color: .btnPrimary, title: "btnPrimary"),
            ColorItem(color: .decorationSubtle, title: "decorationSubtle"),
            ColorItem(color: .iconPrimary, title: "iconPrimary"),
            ColorItem(color: .iconSecondary, title: "iconSecondary"),
            ColorItem(color: .iconTertiary, title: "iconTertiary"),
            ColorItem(color: .imageBorder, title: "imageBorder"),
            ColorItem(color: .tableViewSeparator, title: "tableViewSeparator"),
            ColorItem(color: .textAction, title: "textAction"),
            ColorItem(color: .textCritical, title: "textCritical"),
            ColorItem(color: .textCTADisabled, title: "textCTADisabled"),
            ColorItem(color: .textDisabled, title: "textDisabled"),
            ColorItem(color: .textPrimary, title: "textPrimary"),
            ColorItem(color: .textSecondary, title: "textSecondary"),
            ColorItem(color: .textTertiary, title: "textTertiary"),
            ColorItem(color: .textToast, title: "textToast")
        ]
    }()

    required init?(coder aDecoder: NSCoder) { fatalError() }

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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UITableViewCell.self, for: indexPath)
        let item = items[indexPath.row]
        cell.backgroundColor = item.color

        // TODO: Make extension in DemoKit public.
        let title = item.title.prefix(1).uppercased() + item.title.dropFirst() + "  "
        let attributedTitle = NSMutableAttributedString(string: title)
        attributedTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.gray700, range: NSRange(location: 0, length: title.count))

        let whiteTitle = NSMutableAttributedString(string: title)
        whiteTitle.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.white, range: NSRange(location: 0, length: title.count))
        attributedTitle.append(whiteTitle)
        cell.textLabel?.attributedText = attributedTitle
        cell.textLabel?.font = UIFont.detail
        cell.selectionStyle = .none

        return cell
    }
}
