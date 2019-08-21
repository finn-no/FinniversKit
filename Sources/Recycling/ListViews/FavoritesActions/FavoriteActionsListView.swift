//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol FavoriteActionsListViewDelegate: AnyObject {
    func favoriteActionsListView(_ view: FavoriteActionsListView, didSelectAction action: FavoriteActionsListView.Action)
}

public final class FavoriteActionsListView: UIView {
    public enum Action: Equatable, Hashable, CaseIterable {
        case edit
        case changeName
        case share
        case copyLink
        case delete

//        var icon: UIImage? {
//            switch self {
//            case .edit:
//                return UIImage(named: .favoritesEdit)
//            case .changeName:
//                return UIImage(named: .pencilPaper)
//            case .share:
//                return UIImage(named: .share)
//            case .copyLink:
//                return UIImage(named: .share)
//            case .delete:
//                return UIImage(named: .trashcan)
//            }
//        }
    }

    public static let estimatedRowHeight: CGFloat = 48.0

    // MARK: - Properties

    public weak var delegate: FavoriteActionsListViewDelegate?
    public private(set) var isShared = false
    private let viewModel: FavoriteActionsListViewModel

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .milk
        tableView.rowHeight = FavoriteActionsListView.estimatedRowHeight
        tableView.estimatedRowHeight = FavoriteActionsListView.estimatedRowHeight
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return tableView
    }()

    // MARK: - Init

    public init(viewModel: FavoriteActionsListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Data

    public func toggleSharing() {
        isShared.toggle()
        tableView.reloadData()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
    }
}

// MARK: - UITableViewDataSource

extension FavoriteActionsListView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Action.allCases.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(UITableViewCell.self, for: indexPath)
        let action = Action.allCases[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FavoriteActionsListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = Action.allCases[indexPath.row]
        delegate?.favoriteActionsListView(self, didSelectAction: action)
    }
}
