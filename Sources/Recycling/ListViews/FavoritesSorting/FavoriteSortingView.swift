//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol FavoriteSortingViewDelegate: AnyObject {
    func favoriteSortingView(_ view: FavoriteSortingView, didSelectOption option: FavoriteSortOption)
}

public final class FavoriteSortingView: UIView {
    public static let rowHeight: CGFloat = 48.0
    public static let totalHeight = rowHeight * CGFloat(FavoriteSortOption.allCases.count)

    // MARK: - Public properties

    public weak var delegate: FavoriteSortingViewDelegate?

    // MARK: - Private properties

    private let viewModel: FavoriteSortingViewModel
    private let options = FavoriteSortOption.allCases
    private var selectedSortOption: FavoriteSortOption

    private lazy var tableView: UITableView = {
        let tableView = ContentSizedTableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .milk
        tableView.rowHeight = FavoriteSortingView.rowHeight
        tableView.estimatedRowHeight = FavoriteSortingView.rowHeight
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.separatorColor = .clear
        tableView.register(FavoriteSortOptionCell.self)
        return tableView
    }()

    // MARK: - Init

    public init(viewModel: FavoriteSortingViewModel, selectedSortOption: FavoriteSortOption) {
        self.viewModel = viewModel
        self.selectedSortOption = selectedSortOption
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

extension FavoriteSortingView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = options[indexPath.row]
        let cell = tableView.dequeue(FavoriteSortOptionCell.self, for: indexPath)
        cell.configure(withTitle: viewModel.title(for: option), icon: viewModel.icon(for: option))
        cell.isCheckmarkHidden = option == selectedSortOption
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FavoriteSortingView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        selectedSortOption = options[indexPath.row]
        tableView.reloadData()
        delegate?.favoriteSortingView(self, didSelectOption: selectedSortOption)
    }
}
