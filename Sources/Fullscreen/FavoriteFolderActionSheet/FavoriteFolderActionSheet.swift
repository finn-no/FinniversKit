//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol FavoriteFolderActionSheetDelegate: AnyObject {
    func favoriteFolderActionSheet(_ actionSheet: FavoriteFolderActionSheet, didSelectAction action: FavoriteFolderAction)
}

public final class FavoriteFolderActionSheet: BottomSheet {
    public weak var actionDelegate: FavoriteFolderActionSheetDelegate?

    public var isShared: Bool {
        didSet {
            viewController?.isShared = isShared
            shouldAnimate = true
            height = .makeHeight(for: viewModel, isShared: isShared)
            updatePreferredContentSize()
        }
    }

    private weak var viewController: FavoriteFolderActionViewController?
    private let viewModel: FavoriteFolderActionViewModel
    private var positionObservationToken: NSKeyValueObservation?
    private var animationOffset: CGFloat = 0
    private var shouldAnimate = false

    // MARK: - Init

    public required init(viewModel: FavoriteFolderActionViewModel, isShared: Bool = false) {
        self.isShared = isShared
        self.viewModel = viewModel
        let viewController = FavoriteFolderActionViewController(viewModel: viewModel, isShared: isShared)
        super.init(rootViewController: viewController, height: .makeHeight(for: viewModel, isShared: isShared))
        self.viewController = viewController
        updatePreferredContentSize()
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

        let animationOffsetMultiplier: CGFloat = isPopover ? -2 : (isShared ? 1 : 2)
        let maxTransitionOffset = Height.transitionOffset(for: viewModel)

        positionObservationToken = view.layer.observe(\.position, options: [.new, .old]) { [weak self] _, change in
            guard let self = self, self.shouldAnimate else { return }
            guard let newValue = change.newValue?.y, let oldValue = change.oldValue?.y else { return }

            let offset = animationOffsetMultiplier * (newValue - oldValue)
            self.animationOffset += offset

            if abs(self.animationOffset) <= maxTransitionOffset {
                self.viewController?.animate(with: -offset)
            } else {
                self.shouldAnimate = false
                self.animationOffset = 0
            }
        }
    }

    // MARK: - Public

    public func setAction(_ action: FavoriteFolderAction, enabled: Bool) {
        viewController?.setAction(action, enabled: enabled)
    }

    // MARK: - Private

    private func updatePreferredContentSize() {
        UIView.performWithoutAnimation {
            preferredContentSize.height = height.compact - BottomSheet.Height.bottomInset + notchHeight
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
    static func makeHeight(for viewModel: FavoriteFolderActionViewModel, isShared: Bool) -> BottomSheet.Height {
        let controllerHeight = isShared
            ? FavoriteFolderActionViewController.expandedHeight(for: viewModel)
            : FavoriteFolderActionViewController.compactHeight(for: viewModel)
        let totalHeight = controllerHeight + bottomInset

        return BottomSheet.Height(compact: totalHeight, expanded: totalHeight)
    }

    static func transitionOffset(for viewModel: FavoriteFolderActionViewModel) -> CGFloat {
        return makeHeight(for: viewModel, isShared: true).compact - makeHeight(for: viewModel, isShared: false).compact
    }

    static let bottomInset = UIView.windowSafeAreaInsets.bottom + .largeSpacing
}
