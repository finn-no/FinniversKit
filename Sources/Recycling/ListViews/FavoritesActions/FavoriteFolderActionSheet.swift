//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol FavoriteFolderActionSheetDelegate: AnyObject {
    func favoriteFolderActionSheet(_ actionSheet: FavoriteFolderActionSheet, didSelectAction action: FavoriteFolderAction)
}

public final class FavoriteFolderActionSheet: BottomSheet {
    public weak var actionDelegate: FavoriteFolderActionSheetDelegate?

    public var isCopyLinkHidden = true {
        didSet {
            height = isCopyLinkHidden ? .compact : .expanded
            viewController?.actionsListView.isCopyLinkHidden = isCopyLinkHidden
        }
    }

    private weak var viewController: ActionListViewController?

    // MARK: - Init

    public required init(viewModel: FavoriteActionsListViewModel) {
        let viewController = ActionListViewController(viewModel: viewModel)
        super.init(rootViewController: viewController, height: .compact)
        self.viewController = viewController
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        viewController?.actionsListView.delegate = self
    }
}

// MARK: - FavoriteActionsListViewDelegate

extension FavoriteFolderActionSheet: FavoriteFolderActionsListViewDelegate {
    public func favoriteFolderActionsListView(
        _ view: FavoriteFolderActionsListView,
        didSelectAction action: FavoriteFolderAction
    ) {
        actionDelegate?.favoriteFolderActionSheet(self, didSelectAction: action)
    }
}

// MARK: - Private types

private final class ActionListViewController: UIViewController {
    private let viewModel: FavoriteActionsListViewModel

    private(set) lazy var actionsListView: FavoriteFolderActionsListView = {
        let view = FavoriteFolderActionsListView(viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(viewModel: FavoriteActionsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(actionsListView)
        actionsListView.fillInSuperview()
    }
}

// MARK: - Private extensions

private extension BottomSheet.Height {
    static var compact: BottomSheet.Height {
        let height = FavoriteFolderActionsListView.compactHeight + bottomInset
        return BottomSheet.Height(compact: height, expanded: height)
    }

    static var expanded: BottomSheet.Height {
        let height = FavoriteFolderActionsListView.expandedHeight + bottomInset
        return BottomSheet.Height(compact: height, expanded: height)
    }

    static let bottomInset = UIView.windowSafeAreaInsets.bottom + .mediumLargeSpacing
}
