//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol FavoriteAdNoteSheetDelegate: AnyObject {
    func favoriteAdNoteSheetDidSelectCancel(_ sheet: FavoriteAdNoteSheet)
    func favoriteAdNoteSheet(_ sheet: FavoriteAdNoteSheet, didSelectSaveWithText text: String?)
}

public final class FavoriteAdNoteSheet: BottomSheet {
    public weak var noteDelegate: FavoriteAdNoteSheetDelegate?
    private let viewController: FavoriteAdNoteViewController

    // MARK: - Init

    public required init(
        noteViewModel: FavoriteAdNoteViewModel,
        adViewModel: FavoriteAdViewModel,
        remoteImageViewDataSource: RemoteImageViewDataSource
    ) {
        viewController = FavoriteAdNoteViewController(
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

// MARK: - FavoriteAdNoteViewControllerDelegate

extension FavoriteAdNoteSheet: FavoriteAdNoteViewControllerDelegate {
    func favoriteAdNoteViewControllerDidSelectCancel(_ viewController: FavoriteAdNoteViewController) {
        noteDelegate?.favoriteAdNoteSheetDidSelectCancel(self)
    }

    func favoriteAdNoteViewController(_ viewController: FavoriteAdNoteViewController, didSelectSaveWithText text: String?) {
        noteDelegate?.favoriteAdNoteSheet(self, didSelectSaveWithText: text)
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
