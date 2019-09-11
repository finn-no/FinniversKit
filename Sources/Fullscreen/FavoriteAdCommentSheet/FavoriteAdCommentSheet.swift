//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol FavoriteAdCommentSheetDelegate: AnyObject {
    func favoriteAdCommentSheetDidSelectCancel(_ sheet: FavoriteAdCommentSheet)
    func favoriteAdCommentSheet(_ sheet: FavoriteAdCommentSheet, didSelectSaveWithText text: String?)
}

public final class FavoriteAdCommentSheet: BottomSheet {
    public weak var commentDelegate: FavoriteAdCommentSheetDelegate?
    private let viewController: FavoriteAdCommentViewController

    // MARK: - Init

    public required init(
        commentViewModel: FavoriteAdCommentViewModel,
        adViewModel: FavoriteAdViewModel,
        remoteImageViewDataSource: RemoteImageViewDataSource
    ) {
        viewController = FavoriteAdCommentViewController(
            commentViewModel: commentViewModel,
            adViewModel: adViewModel,
            remoteImageViewDataSource: remoteImageViewDataSource
        )
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.shadowImage = UIImage()

        super.init(rootViewController: navigationController, height: .default)
        viewController.delegate = self
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

// MARK: - FavoriteAdCommentViewControllerDelegate

extension FavoriteAdCommentSheet: FavoriteAdCommentViewControllerDelegate {
    func favoriteAdCommentViewControllerDidSelectCancel(_ viewController: FavoriteAdCommentViewController) {
        commentDelegate?.favoriteAdCommentSheetDidSelectCancel(self)
    }

    func favoriteAdCommentViewController(_ viewController: FavoriteAdCommentViewController, didSelectSaveWithText text: String?) {
        commentDelegate?.favoriteAdCommentSheet(self, didSelectSaveWithText: text)
    }
}

// MARK: - Private extensions

private extension BottomSheet.Height {
    static var `default`: BottomSheet.Height {
        let screenSize = UIScreen.main.bounds.size
        let height = screenSize.height - 64
        return BottomSheet.Height(compact: height, expanded: height)
    }
}
