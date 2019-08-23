//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol FavoriteFolderActionsListViewDelegate: AnyObject {
    func favoriteFolderActionsListView(_ view: FavoriteFolderActionsListView, didSelectAction action: FavoriteFolderAction)
}

public final class FavoriteFolderActionsListView: UIView {
    public static let rowHeight: CGFloat = 48.0
    public static let compactHeight = rowHeight * CGFloat(FavoriteFolderAction.cases(withCopyLink: false).count)
    public static let expandedHeight = rowHeight * CGFloat(FavoriteFolderAction.cases(withCopyLink: true).count)

    // MARK: - Public properties

    public weak var delegate: FavoriteFolderActionsListViewDelegate?

    public var isCopyLinkHidden = true {
        didSet {
            updateActions()
            hideCopyLink(isCopyLinkHidden)
        }
    }

    // MARK: - Private properties

    private let viewModel: FavoriteActionsListViewModel
    private var actions = [FavoriteFolderAction]()

    private lazy var tableView: UITableView = {
        let tableView = ContentSizedTableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .milk
        tableView.rowHeight = FavoriteFolderActionsListView.rowHeight
        tableView.estimatedRowHeight = FavoriteFolderActionsListView.rowHeight
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.register(FavoriteFolderActionCell.self)
        tableView.register(FavoriteFolderShareCell.self)
        tableView.register(FavoriteFolderCopyLinkCell.self)
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
        actions = FavoriteFolderAction.cases(withCopyLink: !isCopyLinkHidden)
    }

    private func hideCopyLink(_ hide: Bool) {
        guard let index = actions.firstIndex(of: .share) else {
            return
        }

        let shareIndexPath = IndexPath(row: index, section: 0)
        let copyLinkIndexPath = IndexPath(row: index + 1, section: 0)

        if hide {
            tableView.deleteRows(at: [copyLinkIndexPath], with: .automatic)
        } else {
            tableView.insertRows(at: [copyLinkIndexPath], with: .automatic)
        }

        if let cell = tableView.cellForRow(at: shareIndexPath) {
            cell.hideSepatator(!hide)
        }
    }
}

// MARK: - UITableViewDataSource

extension FavoriteFolderActionsListView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let action = actions[indexPath.row]

        switch action {
        case .edit:
            let cell = tableView.dequeue(FavoriteFolderActionCell.self, for: indexPath)
            cell.configure(withTitle: viewModel.editText, icon: .favoritesEdit)
            return cell
        case .changeName:
            let cell = tableView.dequeue(FavoriteFolderActionCell.self, for: indexPath)
            cell.configure(withTitle: viewModel.changeNameText, icon: .pencilPaper)
            return cell
        case .share:
            let cell = tableView.dequeue(FavoriteFolderShareCell.self, for: indexPath)
            cell.delegate = self
            cell.configure(withTitle: viewModel.shareText, switchOn: !isCopyLinkHidden)
            return cell
        case .copyLink:
            let cell = tableView.dequeue(FavoriteFolderCopyLinkCell.self, for: indexPath)
            cell.delegate = self
            cell.configure(
                withButtonTitle: viewModel.copyLinkButtonTitle,
                description: viewModel.copyLinkButtonDescription
            )
            return cell
        case .delete:
            let cell = tableView.dequeue(FavoriteFolderActionCell.self, for: indexPath)
            cell.configure(withTitle: viewModel.deleteText, icon: .favoritesDelete, tintColor: .cherry)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension FavoriteFolderActionsListView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        let isLastCell = indexPath.row == actions.count - 1
        let hideSeparator = isLastCell || (action == .share && !isCopyLinkHidden) || action == .copyLink

        cell.hideSepatator(hideSeparator)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = actions[indexPath.row]

        tableView.deselectRow(at: indexPath, animated: true)

        if Set<FavoriteFolderAction>([.edit, .changeName, .delete]).contains(action) {
            delegate?.favoriteFolderActionsListView(self, didSelectAction: action)
        }
    }
}

// MARK: - FavoriteShareViewCellDelegate

extension FavoriteFolderActionsListView: FavoriteFolderShareCellDelegate {
    func favoriteFolderShareCell(_ cell: FavoriteFolderShareCell, didChangeValueFor switchControl: UISwitch) {
        delegate?.favoriteFolderActionsListView(self, didSelectAction: .share)
    }
}

// MARK: - FavoriteCopyLinkViewCellDelegate

extension FavoriteFolderActionsListView: FavoriteFolderCopyLinkCellDelegate {
    func favoriteFolderCopyLinkCellDidSelectButton(_ cell: FavoriteFolderCopyLinkCell) {
        delegate?.favoriteFolderActionsListView(self, didSelectAction: .copyLink)
    }
}

// MARK: - Private types

private extension UITableViewCell {
    func hideSepatator(_ hide: Bool) {
        let inset = hide ? frame.width : FavoriteFolderActionCell.separatorLeadingInset
        separatorInset = .leadingInset(inset)
    }
}
