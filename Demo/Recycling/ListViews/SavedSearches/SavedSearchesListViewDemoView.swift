//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class SavedSearchesDataSource: NSObject {
    let models = SavedSearchFactory.create(numberOfModels: 9)
}

public class SavedSearchesListViewDemoView: UIView {
    lazy var dataSource: SavedSearchesDataSource = {
        return SavedSearchesDataSource()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let view = SavedSearchesListView(delegate: self, dataSource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.fillInSuperview()
    }
}

extension SavedSearchesListViewDemoView: SavedSearchesListViewDelegate {
    public func savedSearchesListView(_ savedSearchesListView: SavedSearchesListView, didSelectItemAtIndex index: Int) {}
}

extension SavedSearchesListViewDemoView: SavedSearchesListViewDataSource {
    public func numberOfItems(inSavedSearchesListView savedSearchesListView: SavedSearchesListView) -> Int {
        return dataSource.models.count
    }

    public func savedSearchesListView(_ savedSearchesListView: SavedSearchesListView, modelAtIndex index: Int) -> SavedSearchesListViewModel {
        return dataSource.models[index]
    }
}
