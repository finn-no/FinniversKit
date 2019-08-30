//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol FavoriteFolderActionSheetDelegate: AnyObject {
    func favoriteFolderActionSheet(_ actionSheet: FavoriteFolderActionSheet, didSelectAction action: FavoriteFolderAction)
}

public final class FavoriteFolderActionSheet: BottomSheet {
    public weak var actionDelegate: FavoriteFolderActionSheetDelegate?

    public var isCopyLinkHidden: Bool {
        didSet {
            viewController?.isCopyLinkHidden = isCopyLinkHidden
            height = .makeHeight(isCopyLinkHidden: isCopyLinkHidden)
        }
    }

    private weak var viewController: FavoriteFolderActionViewController?

    // MARK: - Init

    public required init(viewModel: FavoriteFolderActionViewModel, isCopyLinkHidden: Bool = true) {
        self.isCopyLinkHidden = isCopyLinkHidden
        let viewController = FavoriteFolderActionViewController(viewModel: viewModel, isCopyLinkHidden: isCopyLinkHidden)
        super.init(rootViewController: viewController, height: .makeHeight(isCopyLinkHidden: isCopyLinkHidden))
        self.viewController = viewController
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        viewController?.delegate = self
    }
}

// MARK: - FavoriteFolderActionViewDelegate

extension FavoriteFolderActionSheet: FavoriteFolderActionViewControllerDelegate {
    public func favoriteFolderActionViewController(
        _ viewController: FavoriteFolderActionViewController,
        didSelectAction action: FavoriteFolderAction
    ) {
        actionDelegate?.favoriteFolderActionSheet(self, didSelectAction: action)
    }
}

// MARK: - Private extensions

private extension BottomSheet.Height {
    static func makeHeight(isCopyLinkHidden: Bool) -> BottomSheet.Height {
        return isCopyLinkHidden ? .compact : .expanded
    }

    private static var compact: BottomSheet.Height {
        let height = FavoriteFolderActionViewController.compactHeight + bottomInset
        return BottomSheet.Height(compact: height, expanded: height)
    }

    private static var expanded: BottomSheet.Height {
        let height = FavoriteFolderActionViewController.expandedHeight + bottomInset
        return BottomSheet.Height(compact: height, expanded: height)
    }

    static let bottomInset = UIView.windowSafeAreaInsets.bottom + .largeSpacing
}
