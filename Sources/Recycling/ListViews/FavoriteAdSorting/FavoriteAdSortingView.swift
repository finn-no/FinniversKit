//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol FavoriteAdSortingViewDelegate: AnyObject {
    func favoriteAdSortingView(_ view: FavoriteAdSortingView, didSelectSortOption option: FavoriteAdSortOption)
}

public final class FavoriteAdSortingView: UIView {
    public static let rowHeight: CGFloat = 48.0
    public static let totalHeight = rowHeight * CGFloat(FavoriteAdSortOption.allCases.count)

    // MARK: - Public properties

    public weak var delegate: FavoriteAdSortingViewDelegate?

    // MARK: - Private properties

    private let viewModel: FavoriteAdSortingViewModel
    private let options = FavoriteAdSortOption.allCases
    private var selectedSortOption: FavoriteAdSortOption

    private lazy var tableView: UITableView = {
        let tableView = ContentSizedTableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .milk
        tableView.rowHeight = FavoriteAdSortingView.rowHeight
        tableView.estimatedRowHeight = FavoriteAdSortingView.rowHeight
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.separatorColor = .clear
        tableView.register(FavoriteAdSortOptionCell.self)
        return tableView
    }()

    // MARK: - Init

    public init(viewModel: FavoriteAdSortingViewModel, selectedSortOption: FavoriteAdSortOption) {
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

extension FavoriteAdSortingView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = options[indexPath.row]
        let cell = tableView.dequeue(FavoriteAdSortOptionCell.self, for: indexPath)

        switch option {
        case .lastAdded:
            cell.configure(withTitle: viewModel.lastAddedText, icon: .favoritesSortLastAdded)
        case .status:
            cell.configure(withTitle: viewModel.statusText, icon: .favoritesSortAdStatus)
        case .lastUpdated:
            cell.configure(withTitle: viewModel.lastUpdatedText, icon: .republish)
        case .distance:
            cell.configure(withTitle: viewModel.distanceText, icon: .favoritesSortDistance)
        }

        cell.isCheckmarkHidden = option != selectedSortOption

        return cell
    }
}

// MARK: - UITableViewDelegate

extension FavoriteAdSortingView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSortOption = options[indexPath.row]

        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        delegate?.favoriteAdSortingView(self, didSelectSortOption: selectedSortOption)
    }
}
