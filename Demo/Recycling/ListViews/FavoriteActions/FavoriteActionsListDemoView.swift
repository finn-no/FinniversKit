//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FavoriteActionsListDemoView: UIView {
    private(set) lazy var view: FavoriteActionsListView = {
        let view = FavoriteActionsListView(viewModel: .default)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(view)
        view.fillInSuperview()
    }
}

// MARK: - FavoriteFoldersListViewDelegate

extension FavoriteActionsListDemoView: FavoriteActionsListViewDelegate {
    func favoriteActionsListView(_ view: FavoriteActionsListView, didSelectAction action: FavoriteActionsListView.Action) {
        switch action {
        case .share:
            view.toggleSharing()
        default:
            break
        }
    }
}

// MARK: - Private extensions

private extension FavoriteActionsListViewModel {
    static let `default` = FavoriteActionsListViewModel(
        editText: "Rediger listen",
        changeNameText: "Endre navn på listen",
        shareText: "Deling av listen",
        copyLinkButtonTitle: "Kopier lenke",
        copyLinkButtonDescription: "Alle med lenken kan se listen",
        deleteText: "Slett listen"
    )
}
