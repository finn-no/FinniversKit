//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol FavoriteActionViewDelegate: AnyObject {
    func favoriteActionView(_ view: FavoriteActionView, didSelectAction action: FavoriteAction)
}

public final class FavoriteActionView: UIView {
    public weak var delegate: FavoriteActionViewDelegate?

    // MARK: - Private properties

    private let viewModel: FavoriteActionViewModel
    private let actions = FavoriteAction.allCases

    private lazy var headerView: FavoriteActionHeaderView = {
        let view = FavoriteActionHeaderView(withAutoLayout: true)
        view.configure(
            withImage: viewModel.headerImage,
            detailText: viewModel.headerDetailText,
            accessoryText: viewModel.headerAccessoryText
        )
        return view
    }()

    private lazy var tableView: UITableView = {
        let tableView = ContentSizedTableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .milk
        tableView.rowHeight = FavoriteActionView.rowHeight
        tableView.estimatedRowHeight = FavoriteActionView.rowHeight
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        tableView.register(FavoriteActionCell.self)
        return tableView
    }()

    // MARK: - Init

    public init(viewModel: FavoriteActionViewModel) {
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
}

// MARK: - UITableViewDataSource

extension FavoriteActionView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(FavoriteActionCell.self, for: indexPath)

        switch actions[indexPath.row] {
        case .addNote:
            cell.configure(withTitle: viewModel.addNoteText, icon: .favoritesNote)
        case .delete:
            cell.configure(withTitle: viewModel.deleteText, icon: .favoritesDelete, tintColor: .cherry)
        }

        return cell
    }
}

// MARK: - UITableViewDelegate

extension FavoriteActionView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastCell = indexPath.row == actions.count - 1
        let inset = isLastCell ? frame.width : FavoriteActionCell.separatorLeadingInset
        cell.separatorInset = .leadingInset(inset)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.favoriteActionView(self, didSelectAction: actions[indexPath.row])
    }
}

// MARK: - Static

public extension FavoriteActionView {
    static let rowHeight: CGFloat = 48.0

    static func totalHeight(for viewModel: FavoriteActionViewModel, width: CGFloat) -> CGFloat {
        let headerViewHeight = FavoriteActionHeaderView.height(
            forDetailText: viewModel.headerDetailText,
            accessoryText: viewModel.headerAccessoryText,
            width: width
        )
        let tableViewHeight = rowHeight * CGFloat(FavoriteAction.allCases.count)

        return headerViewHeight + tableViewHeight
    }
}
