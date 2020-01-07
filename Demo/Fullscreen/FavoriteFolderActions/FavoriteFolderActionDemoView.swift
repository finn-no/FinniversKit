//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FavoriteFolderActionDemoView: UIView {
    private(set) lazy var view: FavoriteFolderActionView = {
        let view = FavoriteFolderActionView(viewModel: .default, isShared: true)
        view.delegate = self
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(view)
        view.fillInSuperview()
    }
}

// MARK: - FavoriteAdSortingViewDelegate

extension FavoriteFolderActionDemoView: FavoriteFolderActionViewDelegate {
    func favoriteFolderActionView(
        _ view: FavoriteFolderActionView,
        didSelectAction action: FavoriteFolderAction
    ) {
        print("\(action) selected")

        switch action {
        case .toggleSharing:
            view.isShared = !view.isShared

            if view.isShared {
                view.expand()
            } else {
                view.collapse()
            }
        default:
            break
        }
    }
}

// MARK: - Private extensions

private extension FavoriteFolderActionViewModel {
    static let `default` = FavoriteFolderActionViewModel(
        editText: "Rediger listen",
        renameText: "Endre navn på listen",
        shareToggleText: "Deling av listen",
        shareLinkButtonTitle: "Del listen",
        shareLinkButtonDescription: "Alle med lenken kan se listen",
        deleteText: "Slett listen"
    )
}
