//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class FavoriteActionsListDemoView: UIView {
    private var viewModels: [FavoriteActionViewModel] = [
        .edit(title: "Rediger listen"),
        .changeName(title: "Endre navn på listen"),
        .share(title: "Deling av listen", selected: false),
        .delete(title: "Slett listen")
    ]

    private let copyLink = FavoriteActionViewModel.copyLink(
        title: "Alle med lenken kan se listen",
        buttonTitle: "Kopier lenke"
    )

    private(set) lazy var view: FavoriteActionsListView = {
        let view = FavoriteActionsListView(withAutoLayout: true)
        view.dataSource = self
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
    func favoriteActionsListView(_ favoriteActionsListView: FavoriteActionsListView, didSelectItemAtIndex index: Int) {
        let viewModel = viewModels[index]

        switch viewModel {
        case .share(_, let selected):
            if selected {
                viewModels.insert(copyLink, at: index + 1)
            } else {
                viewModels.remove(at: index + 1)
            }

            view.reloadData()
        default:
            break
        }
    }
}

// MARK: - FavoriteFoldersListViewDataSource

extension FavoriteActionsListDemoView: FavoriteActionsListViewDataSource {
    func numberOfItems(inFavoriteActionsListView view: FavoriteActionsListView) -> Int {
        return viewModels.count
    }

    func favoriteActionsListView(_ view: FavoriteActionsListView, viewModelAtIndex index: Int) -> FavoriteActionViewModel {
        return viewModels[index]
    }
}
