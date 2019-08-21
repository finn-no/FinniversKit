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
    }

    public static let estimatedRowHeight: CGFloat = 48.0

    // MARK: - Public properties

    public weak var delegate: FavoriteActionsListViewDelegate?

    public var isShared = false {
        didSet {
            updateActions()
            showCopyLink(isShared)
        }
    }

    // MARK: - Private properties

    private let viewModel: FavoriteActionsListViewModel
    private var actions = [Action]()

    private lazy var tableView: UITableView = {
        let tableView = TableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .milk
        tableView.rowHeight = FavoriteActionsListView.estimatedRowHeight
        tableView.estimatedRowHeight = FavoriteActionsListView.estimatedRowHeight
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.register(FavoriteActionViewCell.self)
        tableView.register(FavoriteShareViewCell.self)
        tableView.register(FavoriteCopyLinkViewCell.self)
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

    // MARK: - Setup

    private func setup() {
        addSubview(tableView)
        tableView.fillInSuperview()
        updateActions()
    }

    private func updateActions() {
        actions = isShared ? Action.allCases : Action.allCases.filter({ $0 != .copyLink })
    }

    private func showCopyLink(_ show: Bool) {
        guard let index = actions.firstIndex(of: .share) else {
            return
        }

        let shareIndexPath = IndexPath(row: index, section: 0)
        let copyLinkIndexPath = IndexPath(row: index + 1, section: 0)

        if show {
            tableView.insertRows(at: [copyLinkIndexPath], with: .automatic)
        } else {
            tableView.deleteRows(at: [copyLinkIndexPath], with: .automatic)
        }

        if let cell = tableView.cellForRow(at: shareIndexPath) {
            cell.hideSepatator(show)
        }
    }
}

// MARK: - UITableViewDataSource

extension FavoriteActionsListView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let action = actions[indexPath.row]

        switch action {
        case .edit:
            let cell = tableView.dequeue(FavoriteActionViewCell.self, for: indexPath)
            cell.configure(withTitle: viewModel.editText, icon: .favoritesEdit)
            return cell
        case .changeName:
            let cell = tableView.dequeue(FavoriteActionViewCell.self, for: indexPath)
            cell.configure(withTitle: viewModel.changeNameText, icon: .pencilPaper)
            return cell
        case .share:
            let cell = tableView.dequeue(FavoriteShareViewCell.self, for: indexPath)
            cell.delegate = self
            cell.configure(withTitle: viewModel.shareText, switchOn: isShared)
            return cell
        case .copyLink:
            let cell = tableView.dequeue(FavoriteCopyLinkViewCell.self, for: indexPath)
            cell.delegate = self
            cell.configure(
                withButtonTitle: viewModel.copyLinkButtonTitle,
                description: viewModel.copyLinkButtonDescription
            )
            return cell
        case .delete:
            let cell = tableView.dequeue(FavoriteActionViewCell.self, for: indexPath)
            cell.configure(withTitle: viewModel.deleteText, icon: .favoritesDelete, tintColor: .cherry)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension FavoriteActionsListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        let isLastCell = indexPath.row == actions.count - 1
        let hideSeparator = isLastCell || (action == .share && isShared) || action == .copyLink

        cell.hideSepatator(hideSeparator)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = actions[indexPath.row]

        tableView.deselectRow(at: indexPath, animated: true)

        if Set<Action>([.edit, .changeName, .delete]).contains(action) {
            delegate?.favoriteActionsListView(self, didSelectAction: action)
        }
    }
}

// MARK: - FavoriteShareViewCellDelegate

extension FavoriteActionsListView: FavoriteShareViewCellDelegate {
    func favoriteShareViewCell(_ cell: FavoriteShareViewCell, didChangeValueFor switchControl: UISwitch) {
        delegate?.favoriteActionsListView(self, didSelectAction: .share)
    }
}

// MARK: - FavoriteCopyLinkViewCellDelegate

extension FavoriteActionsListView: FavoriteCopyLinkViewCellDelegate {
    func favoriteCopyLinkViewCellDidSelectButton(_ cell: FavoriteCopyLinkViewCell) {
        delegate?.favoriteActionsListView(self, didSelectAction: .copyLink)
    }
}

// MARK: - Private types

private final class TableView: UITableView {
    override var intrinsicContentSize: CGSize {
        return contentSize
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if bounds.size != intrinsicContentSize {
            invalidateIntrinsicContentSize()
        }
    }
}

private extension UITableViewCell {
    func hideSepatator(_ hide: Bool) {
        let inset = hide ? frame.width : FavoriteActionViewCell.separatorLeadingInset
        separatorInset = .leadingInset(inset)
    }
}
