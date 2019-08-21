//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol FavoriteActionsBottomSheetDelegate: AnyObject {
    func favoriteActionsBottomSheet(_ bottomSheet: FavoriteActionsBottomSheet, didSelectAction action: FavoriteActionsListView.Action)
}

public final class FavoriteActionsBottomSheet: BottomSheet {
    public weak var actionsDelegate: FavoriteActionsBottomSheetDelegate?
    private let viewController: ActionListViewController

    public var isShared = false {
        didSet {
            height = isShared ? .expanded : .compact
            viewController.actionsListView.isShared = isShared
        }
    }

    // MARK: - Init

    public required init(viewModel: FavoriteActionsListViewModel) {
        self.viewController = ActionListViewController(viewModel: viewModel)
        super.init(rootViewController: viewController, height: .compact)
        viewController.delegate = self
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

// MARK: - FavoriteActionsListViewDelegate

extension FavoriteActionsBottomSheet: FavoriteActionsListViewDelegate {
    public func favoriteActionsListView(_ view: FavoriteActionsListView, didSelectAction action: FavoriteActionsListView.Action) {
        actionsDelegate?.favoriteActionsBottomSheet(self, didSelectAction: action)
    }
}

// MARK: - Private types

private final class ActionListViewController: UIViewController {
    private let viewModel: FavoriteActionsListViewModel
    weak var delegate: FavoriteActionsListViewDelegate?

    private(set) lazy var actionsListView: FavoriteActionsListView = {
        let view = FavoriteActionsListView(viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = delegate
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
        let height = FavoriteActionsListView.compactHeight + bottomInset
        return BottomSheet.Height(compact: height, expanded: height)
    }

    static var expanded: BottomSheet.Height {
        let height = FavoriteActionsListView.expandedHeight + bottomInset
        return BottomSheet.Height(compact: height, expanded: height)
    }

    static let bottomInset = UIView.windowSafeAreaInsets.bottom + .mediumLargeSpacing
}
