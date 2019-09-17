//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol FavoriteFolderActionViewControllerDelegate: AnyObject {
    func favoriteFolderActionViewController(
        _ viewController: FavoriteFolderActionViewController,
        didSelectAction action: FavoriteFolderAction
    )
}

public final class FavoriteFolderActionViewController: UIViewController {
    public static let rowHeight: CGFloat = 48.0
    public static let compactHeight = rowHeight * CGFloat(FavoriteFolderAction.cases(withCopyLink: false).count)
    public static let expandedHeight = rowHeight * CGFloat(FavoriteFolderAction.cases(withCopyLink: true).count)

    // MARK: - Public properties

    public weak var delegate: FavoriteFolderActionViewControllerDelegate?

    public var isCopyLinkHidden: Bool {
        didSet {
           reloadData()
        }
    }

    // MARK: - Private properties

    private let viewModel: FavoriteFolderActionViewModel
    private let topActions: [FavoriteFolderAction] = [.edit, .changeName, .share, .copyLink, .delete]

    private lazy var topTableView: UITableView = {
        let tableView = UITableView.default
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FavoriteActionCell.self)
        tableView.register(FavoriteFolderShareCell.self)
        tableView.register(FavoriteActionCell.self)
        tableView.register(FavoriteFolderCopyLinkCell.self)
        return tableView
    }()

//    private lazy var bottomTableView: UITableView = {
//        let tableView = UITableView.default
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.register(FavoriteActionCell.self)
//        tableView.register(FavoriteFolderCopyLinkCell.self)
//        return tableView
//    }()

    // MARK: - Init

    public init(viewModel: FavoriteFolderActionViewModel, isCopyLinkHidden: Bool = true) {
        self.viewModel = viewModel
        self.isCopyLinkHidden = isCopyLinkHidden
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    // MARK: - Setup

    private func setup() {
        //view.addSubview(bottomTableView)
        view.addSubview(topTableView)

        //let bottomOffset = view.windowSafeAreaInsets.bottom + .mediumSpacing + .smallSpacing

        NSLayoutConstraint.activate([
            topTableView.topAnchor.constraint(equalTo: view.topAnchor),
            topTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),

//            bottomTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomOffset),
//            bottomTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            bottomTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }

    private func reloadData() {
        guard let shareIndex = topActions.firstIndex(of: .share) else { return }
        guard let copyLinkIndex = topActions.firstIndex(of: .copyLink) else { return }
        guard let deleteIndex = topActions.firstIndex(of: .delete) else { return }
        guard let cell = topTableView.cellForRow(at: IndexPath(row: copyLinkIndex, section: 0)) else { return }
        guard let deleteCell = topTableView.cellForRow(at: IndexPath(row: deleteIndex, section: 0)) else { return }

        // Hide separator on the share cell
        topTableView.cellForRow(at: IndexPath(row: shareIndex, section: 0))?.hideSepatator(!isCopyLinkHidden)

        // Animate copy link cell appearance
        let transform = CGAffineTransform(translationX: 0, y: .mediumLargeSpacing)
        let transform2 = CGAffineTransform(translationX: 0, y: -FavoriteFolderActionViewController.rowHeight)


        topTableView.sendSubviewToBack(cell)
        cell.alpha = isCopyLinkHidden ? 1 : 0
        cell.transform = isCopyLinkHidden ? .identity : transform

        deleteCell.transform = isCopyLinkHidden ? .identity : transform2

        UIView.animate(withDuration: 0.19) {
            cell.alpha = self.isCopyLinkHidden ? 0 : 1
            cell.transform = self.isCopyLinkHidden ? transform : .identity
            deleteCell.transform = self.isCopyLinkHidden ? transform2 : .identity
        }
    }

    private func actions(for tableView: UITableView) -> [FavoriteFolderAction] {
        return topActions
    }
}

// MARK: - UITableViewDataSource

extension FavoriteFolderActionViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions(for: tableView).count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let action = actions(for: tableView)[indexPath.row]

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

extension FavoriteFolderActionViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let action = actions(for: tableView)[indexPath.row]
        let hideSeparator = (action == .share && !isCopyLinkHidden) || action == .copyLink || action == .delete

        cell.hideSepatator(hideSeparator)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let action = actions(for: tableView)[indexPath.row]

        tableView.deselectRow(at: indexPath, animated: true)

        if Set<FavoriteFolderAction>([.edit, .changeName, .delete]).contains(action) {
            delegate?.favoriteFolderActionViewController(self, didSelectAction: action)
        }
    }
}

// MARK: - FavoriteShareViewCellDelegate

extension FavoriteFolderActionViewController: FavoriteFolderShareCellDelegate {
    func favoriteFolderShareCell(_ cell: FavoriteFolderShareCell, didChangeValueFor switchControl: UISwitch) {
        delegate?.favoriteFolderActionViewController(self, didSelectAction: .share)
    }
}

// MARK: - FavoriteCopyLinkViewCellDelegate

extension FavoriteFolderActionViewController: FavoriteFolderCopyLinkCellDelegate {
    func favoriteFolderCopyLinkCellDidSelectButton(_ cell: FavoriteFolderCopyLinkCell) {
        delegate?.favoriteFolderActionViewController(self, didSelectAction: .copyLink)
    }
}

// MARK: - Private extensions

private extension UITableView {
    static var `default`: UITableView {
        let tableView = ContentSizedTableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .milk
        tableView.rowHeight = FavoriteFolderActionViewController.rowHeight
        tableView.estimatedRowHeight = FavoriteFolderActionViewController.rowHeight
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return tableView
    }
}

private extension UITableViewCell {
    func hideSepatator(_ hide: Bool) {
        let inset = hide ? frame.width : FavoriteActionCell.separatorLeadingInset
        separatorInset = .leadingInset(inset)
    }
}
