//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol SelectionViewDelegate: AnyObject {
    func selectionView(_ view: SelectionView, didSelectOptionAtIndex index: Int)
}

public protocol SelectionViewDataSource: AnyObject {
    func numberOfOptions(inSelectionView: SelectionView) -> Int
    func selectionView(_ view: SelectionView, viewModelForOptionAt index: Int) -> OptionCellViewModel
}

public final class SelectionView: UIView {
    public static let rowHeight: CGFloat = 48.0

    // MARK: - Public properties

    public weak var delegate: SelectionViewDelegate?

    // MARK: - Private properties

    private var selectedIndex: Int

    private lazy var tableView: UITableView = {
        let tableView = ContentSizedTableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .bgPrimary
        tableView.rowHeight = SelectionView.rowHeight
        tableView.estimatedRowHeight = SelectionView.rowHeight
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.separatorColor = .clear
        tableView.register(OptionCell.self)
        return tableView
    }()

    private weak var dataSource: SelectionViewDataSource?

    // MARK: - Init

    public init(dataSource: SelectionViewDataSource, selectedIndex: Int) {
        self.dataSource = dataSource
        self.selectedIndex = selectedIndex
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

extension SelectionView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource?.numberOfOptions(inSelectionView: self) ?? 0
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(OptionCell.self, for: indexPath)
        let index = indexPath.row

        guard
            let viewModel = dataSource?.selectionView(self, viewModelForOptionAt: index)
        else { return cell }

        cell.configure(with: viewModel)
        cell.isCheckmarkHidden = index != selectedIndex
        cell.accessibilityLabel = viewModel.accessibilityLabel
        cell.accessibilityHint = viewModel.accessibilityHint

        return cell
    }
}

// MARK: - UITableViewDelegate

extension SelectionView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row

        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        delegate?.selectionView(self, didSelectOptionAtIndex: selectedIndex)
    }
}
