//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol FavoriteAdActionViewDelegate: AnyObject {
    func favoriteAdActionView(_ view: FavoriteAdActionView, didSelectAction action: FavoriteAdAction)
}

public final class FavoriteAdActionView: UIView {
    public weak var delegate: FavoriteAdActionViewDelegate?

    // MARK: - Private properties

    private let viewModel: FavoriteAdActionViewModel
    private let actions = FavoriteAdAction.allCases

    private lazy var headerView: FavoriteAdActionHeaderView = {
        let view = FavoriteAdActionHeaderView(withAutoLayout: true)
        view.configure(withImage: viewModel.headerImage, title: viewModel.headerTitle)
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = ContentSizedTableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .background
        tableView.estimatedRowHeight = 48
        tableView.tableFooterView = UIView()
        tableView.alwaysBounceVertical = false
        tableView.register(FavoriteActionCell.self)
        return tableView
    }()

    // MARK: - Init

    public init(viewModel: FavoriteAdActionViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(headerView)
        addSubview(tableView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: topAnchor),
            headerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: trailingAnchor),

            tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Overrides

    public override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority
    ) -> CGSize {
        let requiredHeight = Self.totalHeight(for: viewModel, width: targetSize.width)

        return CGSize(
            width: targetSize.width,
            height: requiredHeight
        )
    }
}

// MARK: - UITableViewDataSource

extension FavoriteAdActionView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(FavoriteActionCell.self, for: indexPath)

        switch actions[indexPath.row] {
        case .comment:
            cell.configure(withTitle: viewModel.commentText, icon: .favoritesNote)
        case .share:
            cell.configure(withTitle: viewModel.shareText, icon: .favoritesShare)
        case .delete:
            cell.configure(withTitle: viewModel.deleteText, icon: .favoritesDelete, tintColor: .textNegative)
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension FavoriteAdActionView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == actions.count - 1
        let inset = isLastCell ? frame.width : FavoriteActionCell.separatorLeadingInset
        cell.separatorInset = .leadingInset(inset)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.favoriteAdActionView(self, didSelectAction: actions[indexPath.row])
    }
}

// MARK: - Static

public extension FavoriteAdActionView {
    static func totalHeight(for viewModel: FavoriteAdActionViewModel, width: CGFloat, method: String = #function) -> CGFloat {
        let headerViewHeight = FavoriteAdActionHeaderView.height(forTitle: viewModel.headerTitle, width: width)

        let tableViewHeight = viewModel.actionTitles.reduce(0) { sum, actionTitle in
            sum + FavoriteActionCell.height(forWidth: width, usingText: actionTitle)
        }

        return headerViewHeight + tableViewHeight
    }
}

// MARK: - Private extensions

private extension FavoriteAdActionViewModel {
    var actionTitles: [String] {
        [commentText, shareText, deleteText]
    }
}
