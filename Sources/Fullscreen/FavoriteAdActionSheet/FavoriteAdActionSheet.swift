//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol FavoriteAdActionSheetDelegate: AnyObject {
    func favoriteAdActionSheet(_ sheet: FavoriteAdActionSheet, didSelectAction action: FavoriteAdAction)
}

public final class FavoriteAdActionSheet: BottomSheet {
    public weak var actionDelegate: FavoriteAdActionSheetDelegate?
    private let viewModel: FavoriteAdActionViewModel

    private(set) lazy var actionView: FavoriteAdActionView = {
        let view = FavoriteAdActionView(viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    // MARK: - Init

    public required init(viewModel: FavoriteAdActionViewModel) {
        self.viewModel = viewModel
        super.init(rootViewController: UIViewController(), height: .height(for: viewModel))
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

        rootViewController.view.addSubview(actionView)
        actionView.fillInSuperview()
    }
}

// MARK: - FavoriteActionsListViewDelegate

extension FavoriteAdActionSheet: FavoriteAdActionViewDelegate {
    public func favoriteAdActionView(_ view: FavoriteAdActionView, didSelectAction action: FavoriteAdAction) {
        actionDelegate?.favoriteAdActionSheet(self, didSelectAction: action)
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
