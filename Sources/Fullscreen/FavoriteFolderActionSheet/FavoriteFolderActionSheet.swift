//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol FavoriteFolderActionSheetDelegate: AnyObject {
    func favoriteFolderActionSheet(_ actionSheet: FavoriteFolderActionSheet, didSelectAction action: FavoriteFolderAction)
}

public final class FavoriteFolderActionSheet: BottomSheet {
    public weak var actionDelegate: FavoriteFolderActionSheetDelegate?

    public var isCopyLinkHidden = true {
        didSet {
            height = isCopyLinkHidden ? .compact : .expanded
            viewController?.actionView.isCopyLinkHidden = isCopyLinkHidden
        }
    }

    private weak var viewController: FolderActionViewController?

    // MARK: - Init

    public required init(viewModel: FavoriteFolderActionViewModel) {
        let viewController = FolderActionViewController(viewModel: viewModel)
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

// MARK: - FavoriteFolderActionViewDelegate

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

    private(set) lazy var actionView: FavoriteFolderActionView = {
        let view = FavoriteFolderActionView(viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    init(viewModel: FavoriteFolderActionViewModel) {
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

    static var expanded: BottomSheet.Height {
        let height = FavoriteFolderActionView.expandedHeight + bottomInset
        return BottomSheet.Height(compact: height, expanded: height)
    }

    static let bottomInset = UIView.windowSafeAreaInsets.bottom + .mediumLargeSpacing
}
