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
            height = .makeHeight(isCopyLinkHidden: isCopyLinkHidden)
            viewController?.actionView.isCopyLinkHidden = isCopyLinkHidden
        }
    }

    private weak var viewController: FolderActionViewController?

    // MARK: - Init

    public required init(viewModel: FavoriteFolderActionViewModel, isCopyLinkHidden: Bool = true) {
        self.isCopyLinkHidden = isCopyLinkHidden
        let viewController = FolderActionViewController(viewModel: viewModel, isCopyLinkHidden: isCopyLinkHidden)
        super.init(rootViewController: viewController, height: .makeHeight(isCopyLinkHidden: isCopyLinkHidden))
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

extension FavoriteFolderActionSheet: FavoriteFolderActionViewDelegate {
    public func favoriteFolderActionView(
        _ view: FavoriteFolderActionView,
        didSelectAction action: FavoriteFolderAction
    ) {
        actionDelegate?.favoriteFolderActionSheet(self, didSelectAction: action)
    }
}

// MARK: - Private types

private final class FolderActionViewController: UIViewController {
    private let viewModel: FavoriteFolderActionViewModel
    private let isCopyLinkHidden: Bool

    private(set) lazy var actionView: FavoriteFolderActionView = {
        let view = FavoriteFolderActionView(viewModel: viewModel, isCopyLinkHidden: isCopyLinkHidden)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(viewModel: FavoriteFolderActionViewModel, isCopyLinkHidden: Bool) {
        self.viewModel = viewModel
        self.isCopyLinkHidden = isCopyLinkHidden
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
    static func makeHeight(isCopyLinkHidden: Bool) -> BottomSheet.Height {
        return isCopyLinkHidden ? .compact : .expanded
    }

    private static var compact: BottomSheet.Height {
        let height = FavoriteFolderActionView.compactHeight + bottomInset
        return BottomSheet.Height(compact: height, expanded: height)
    }

    private static var expanded: BottomSheet.Height {
        let height = FavoriteFolderActionView.expandedHeight + bottomInset
        return BottomSheet.Height(compact: height, expanded: height)
    }

    private static let bottomInset = UIView.windowSafeAreaInsets.bottom + .mediumLargeSpacing
}
