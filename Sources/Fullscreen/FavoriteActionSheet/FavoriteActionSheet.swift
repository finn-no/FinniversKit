//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol FavoriteActionSheetDelegate: AnyObject {
    func favoriteActionSheet(_ actionSheet: FavoriteActionSheet, didSelectAction action: FavoriteAction)
}

public final class FavoriteActionSheet: BottomSheet {
    public weak var actionDelegate: FavoriteActionSheetDelegate?
    private weak var viewController: ActionViewController?

    // MARK: - Init

    public required init(viewModel: FavoriteActionViewModel) {
        let viewController = ActionViewController(viewModel: viewModel)
        super.init(rootViewController: viewController, height: .compact)
        self.viewController = viewController
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        viewController?.actionView.delegate = self
    }
}

// MARK: - FavoriteActionsListViewDelegate

extension FavoriteActionSheet: FavoriteActionViewDelegate {
    public func favoriteActionView(_ view: FavoriteActionView, didSelectAction action: FavoriteAction) {
        actionDelegate?.favoriteActionSheet(self, didSelectAction: action)
    }
}

// MARK: - Private types

private final class ActionViewController: UIViewController {
    private let viewModel: FavoriteActionViewModel

    private(set) lazy var actionView: FavoriteActionView = {
        let view = FavoriteActionView(viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(viewModel: FavoriteActionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(actionView)
        actionView.fillInSuperview()
    }
}

// MARK: - Private extensions

private extension BottomSheet.Height {
    static var compact: BottomSheet.Height {
        let height = FavoriteFolderActionView.compactHeight + bottomInset
        return BottomSheet.Height(compact: height, expanded: height)
    }

    static let bottomInset = UIView.windowSafeAreaInsets.bottom + .mediumLargeSpacing
}
