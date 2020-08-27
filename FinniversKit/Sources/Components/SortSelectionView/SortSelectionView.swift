//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol SortSelectionViewDelegate: AnyObject {
    func sortSelectionView(_ view: SortSelectionView, didSelectSortOptionWithIdentifier selectedIdentifier: String)
}

public final class SortSelectionView: UIView {
    public static let rowHeight: CGFloat = 48.0

    // MARK: - Public properties

    public weak var delegate: SortSelectionViewDelegate?

    // MARK: - Private properties

    private let options: [SortSelectionOptionModel]
    private var selectedSortOptionIdentifier: String

    private lazy var tableView: UITableView = {
        let tableView = ContentSizedTableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .bgPrimary
        tableView.rowHeight = SortSelectionView.rowHeight
        tableView.estimatedRowHeight = SortSelectionView.rowHeight
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.separatorColor = .clear
        tableView.register(SortSelectionOptionCell.self)
        return tableView
    }()

    // MARK: - Init

    public init(
        sortingOptions options: [SortSelectionOptionModel],
        selectedSortOptionIdentifier: String
    ) {
        self.options = options
        self.selectedSortOptionIdentifier = selectedSortOptionIdentifier
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
    }
}

// MARK: - UITableViewDataSource

extension SortSelectionView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        options.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = options[indexPath.row]
        let cell = tableView.dequeue(SortSelectionOptionCell.self, for: indexPath)

        cell.configure(withTitle: option.title, icon: option.icon)

        cell.isCheckmarkHidden = option.identifier != selectedSortOptionIdentifier

        return cell
    }
}

// MARK: - UITableViewDelegate

extension SortSelectionView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSortOptionIdentifier = options[indexPath.row].identifier

        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        delegate?.sortSelectionView(self, didSelectSortOptionWithIdentifier: selectedSortOptionIdentifier)
    }
}
