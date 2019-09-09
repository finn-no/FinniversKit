//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol FavoriteAdActionSheetDelegate: AnyObject {
    func favoriteAdActionSheet(_ sheet: FavoriteAdActionSheet, didSelectAction action: FavoriteAdAction)
}

public final class FavoriteAdActionSheet: BottomSheet {
    public weak var actionDelegate: FavoriteAdActionSheetDelegate?
    private weak var viewController: ActionViewController?

    // MARK: - Init

    public required init(viewModel: FavoriteAdActionViewModel) {
        let viewController = ActionViewController(viewModel: viewModel)
        super.init(rootViewController: viewController, height: .height(for: viewModel))
        self.viewController = viewController
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .prominent))
        notch.insertSubview(blurView, at: 0)
        blurView.fillInSuperview()

        viewController?.actionView.delegate = self
    }
}

// MARK: - FavoriteActionsListViewDelegate

extension FavoriteAdActionSheet: FavoriteAdActionViewDelegate {
    public func favoriteAdActionView(_ view: FavoriteAdActionView, didSelectAction action: FavoriteAdAction) {
        actionDelegate?.favoriteAdActionSheet(self, didSelectAction: action)
    }
}

// MARK: - Private types

private final class ActionViewController: UIViewController {
    private let viewModel: FavoriteAdActionViewModel

    private(set) lazy var actionView: FavoriteAdActionView = {
        let view = FavoriteAdActionView(viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(viewModel: FavoriteAdActionViewModel) {
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
    static func height(for viewModel: FavoriteAdActionViewModel) -> BottomSheet.Height {
        let bottomInset = UIView.windowSafeAreaInsets.bottom + .largeSpacing
        let height = FavoriteAdActionView.totalHeight(for: viewModel, width: UIScreen.main.bounds.width) + bottomInset
        return BottomSheet.Height(compact: height, expanded: height)
    }
}
