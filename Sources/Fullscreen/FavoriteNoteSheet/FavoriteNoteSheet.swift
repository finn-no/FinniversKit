//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol FavoriteNoteSheetDelegate: AnyObject {
    func favoriteNoteSheetDidSelectCancel(_ sheet: FavoriteNoteSheet)
    func favoriteNoteSheet(_ sheet: FavoriteNoteSheet, didSelectSaveWithText text: String?)
}

public final class FavoriteNoteSheet: BottomSheet {
    public weak var noteDelegate: FavoriteNoteSheetDelegate?
    private let viewController: FavoriteNoteViewController

    // MARK: - Init

    public required init(
        noteViewModel: FavoriteNoteViewModel,
        adViewModel: FavoriteAdViewModel,
        remoteImageViewDataSource: RemoteImageViewDataSource
    ) {
        viewController = FavoriteNoteViewController(
            noteViewModel: noteViewModel,
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

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - FavoriteNoteViewControllerDelegate

extension FavoriteNoteSheet: FavoriteNoteViewControllerDelegate {
    func favoriteNoteViewControllerDidSelectCancel(_ viewController: FavoriteNoteViewController) {
        noteDelegate?.favoriteNoteSheetDidSelectCancel(self)
    }

    func favoriteNoteViewController(_ viewController: FavoriteNoteViewController, didSelectSaveWithText text: String?) {
        noteDelegate?.favoriteNoteSheet(self, didSelectSaveWithText: text)
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
