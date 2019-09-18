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
            shouldAnimate = true
            height = .makeHeight(isCopyLinkHidden: isCopyLinkHidden)
        }
    }

    private weak var viewController: FavoriteFolderActionViewController?
    private var positionObservationToken: NSKeyValueObservation?
    private var animationOffset: CGFloat = 0
    private var shouldAnimate = false

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

    deinit {
        positionObservationToken?.invalidate()
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()
        viewController?.delegate = self

        let animationOffsetMultiplier: CGFloat = isCopyLinkHidden ? 2 : 1
        let maxTransitionOffset = Height.transitionOffset

        positionObservationToken = view.layer.observe(\.position, options: [.new, .old]) { [weak self] _, change in
            guard let self = self, self.shouldAnimate else { return }
            guard let newValue = change.newValue?.y, let oldValue = change.oldValue?.y else { return }

            let offset = animationOffsetMultiplier * (newValue - oldValue)
            self.animationOffset += offset

            if abs(self.animationOffset) <= maxTransitionOffset {
                self.viewController?.animateRows(with: -offset)
            } else {
                self.shouldAnimate = false
                self.animationOffset = 0
            }
        }
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
        return isCopyLinkHidden ? .withoutCopyLink : .withCopyLink
    }

    static var transitionOffset: CGFloat {
        return withCopyLink.compact - withoutCopyLink.compact
    }

    private static var withoutCopyLink: BottomSheet.Height {
        let height = FavoriteFolderActionViewController.compactHeight + bottomInset
        return BottomSheet.Height(compact: height, expanded: height)
    }

    private static var withCopyLink: BottomSheet.Height {
        let height = FavoriteFolderActionViewController.expandedHeight + bottomInset
        return BottomSheet.Height(compact: height, expanded: height)
    }

    private static let bottomInset = UIView.windowSafeAreaInsets.bottom + .largeSpacing
}
