//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class FavoriteFoldersDataSource: NSObject {
    let favorites = FavoriteFoldersFactory.create()
}

public class FavoriteFoldersListViewDemoView: UIView {
    lazy var dataSource: FavoriteFoldersDataSource = {
        return FavoriteFoldersDataSource()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let view = FavoriteFoldersListView(delegate: self, dataSource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.fillInSuperview()
    }
}

extension FavoriteFoldersListViewDemoView: FavoriteFoldersListViewDelegate {
    public func favoriteFoldersListView(_ favoriteFoldersListView: FavoriteFoldersListView, didSelectItemAtIndex index: Int) {}
}

extension FavoriteFoldersListViewDemoView: FavoriteFoldersListViewDataSource {
    public func numberOfItems(inFavoriteFoldersListView favoriteFoldersListView: FavoriteFoldersListView) -> Int {
        return dataSource.favorites.count
    }

    public func favoriteFoldersListView(_ favoriteFoldersListView: FavoriteFoldersListView, modelAtIndex index: Int) -> FavoriteFoldersListViewModel {
        return dataSource.favorites[index]
    }
}
