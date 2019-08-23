//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol FavoriteFolderActionViewDelegate: AnyObject {
    func favoriteFolderActionView(_ view: FavoriteFolderActionView, didSelectAction action: FavoriteFolderAction)
}

public final class FavoriteFolderActionView: UIView {
    public static let rowHeight: CGFloat = 48.0
    public static let compactHeight = rowHeight * CGFloat(FavoriteFolderAction.cases(withCopyLink: false).count)
    public static let expandedHeight = rowHeight * CGFloat(FavoriteFolderAction.cases(withCopyLink: true).count)

    // MARK: - Public properties

    public weak var delegate: FavoriteFolderActionViewDelegate?

    public var isCopyLinkHidden = true {
        didSet {
            updateActions()
            hideCopyLink(isCopyLinkHidden)
        }
    }

    // MARK: - Private properties

    private let viewModel: FavoriteFolderActionViewModel
    private var actions = [FavoriteFolderAction]()

    private lazy var tableView: UITableView = {
        let tableView = ContentSizedTableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .milk
        tableView.rowHeight = FavoriteFolderActionView.rowHeight
        tableView.estimatedRowHeight = FavoriteFolderActionView.rowHeight
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.register(FavoriteActionCell.self)
        tableView.register(FavoriteFolderShareCell.self)
        tableView.register(FavoriteFolderCopyLinkCell.self)
        return tableView
    }()

    // MARK: - Init

    public init(viewModel: FavoriteFolderActionViewModel) {
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

extension FavoriteFolderActionView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let action = actions[indexPath.row]

        switch action {
        case .edit:
            let cell = tableView.dequeue(FavoriteActionCell.self, for: indexPath)
            cell.configure(withTitle: viewModel.editText, icon: .favoritesEdit)
            return cell
        case .changeName:
            let cell = tableView.dequeue(FavoriteActionCell.self, for: indexPath)
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
            let cell = tableView.dequeue(FavoriteActionCell.self, for: indexPath)
            cell.configure(withTitle: viewModel.deleteText, icon: .favoritesDelete, tintColor: .cherry)
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension FavoriteFolderActionView: UITableViewDelegate {
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
            delegate?.favoriteFolderActionView(self, didSelectAction: action)
        }
    }
}

// MARK: - FavoriteShareViewCellDelegate

extension FavoriteFolderActionView: FavoriteFolderShareCellDelegate {
    func favoriteFolderShareCell(_ cell: FavoriteFolderShareCell, didChangeValueFor switchControl: UISwitch) {
        delegate?.favoriteFolderActionView(self, didSelectAction: .share)
    }
}

// MARK: - FavoriteCopyLinkViewCellDelegate

extension FavoriteFolderActionView: FavoriteFolderCopyLinkCellDelegate {
    func favoriteFolderCopyLinkCellDidSelectButton(_ cell: FavoriteFolderCopyLinkCell) {
        delegate?.favoriteFolderActionView(self, didSelectAction: .copyLink)
    }
}

// MARK: - Private types

private extension UITableViewCell {
    func hideSepatator(_ hide: Bool) {
        let inset = hide ? frame.width : FavoriteActionCell.separatorLeadingInset
        separatorInset = .leadingInset(inset)
    }
}
