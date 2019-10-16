//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol BasicTableViewDelegate: AnyObject {
    func basicTableView(_ basicTableView: BasicTableView, didSelectItemAtIndex index: Int)
}

open class BasicTableViewItem: BasicTableViewCellViewModel {
    open var title: String
    open var subtitle: String?
    open var detailText: String?
    open var hasChevron: Bool
    open var isEnabled: Bool = true

    public init(title: String) {
        self.title = title
        self.hasChevron = false
    }
}

open class BasicTableView: ShadowScrollView {
    public static let estimatedRowHeight: CGFloat = 60.0
    open var selectedIndexPath: IndexPath?
    open var items: [BasicTableViewItem]

    // MARK: - Internal properties

    private lazy var tableView: UITableView = {
        let tableView = UITableView(withAutoLayout: true)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .bgPrimary
        tableView.estimatedRowHeight = BasicTableView.estimatedRowHeight
        tableView.separatorColor = .tableViewSeparator
        tableView.separatorInset = .leadingInset(frame.width)
        return tableView
    }()

    private var usingShadowWhenScrolling: Bool = false

    public weak var delegate: BasicTableViewDelegate?

    // MARK: - Setup

    public init(items: [BasicTableViewItem], usingShadowWhenScrolling: Bool = false) {
        self.usingShadowWhenScrolling = usingShadowWhenScrolling
        self.items = items
        super.init(frame: .zero)
        setup()
    }

    public override init(frame: CGRect) {
        self.items = [BasicTableViewItem]()
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        self.items = [BasicTableViewItem]()
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .bgPrimary
        tableView.register(BasicTableViewCell.self)

        if usingShadowWhenScrolling {
            insertSubview(tableView, belowSubview: topShadowView)
            let anchor = topShadowView.bottomAnchor.constraint(equalTo: topAnchor)
            anchor.isActive = true
        } else {
            addSubview(tableView)
        }
        tableView.fillInSuperview()
    }
}

// MARK: - UITableViewDelegate

extension BasicTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        if item.isEnabled {
            delegate?.basicTableView(self, didSelectItemAtIndex: indexPath.row)
        }
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}

// MARK: - UITableViewDataSource

extension BasicTableView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(BasicTableViewCell.self, for: indexPath)

        let item = items[indexPath.row]
        cell.selectedIndexPath = selectedIndexPath
        cell.isEnabled = item.isEnabled
        cell.configure(with: item, indexPath: indexPath)

        return cell
    }
}
