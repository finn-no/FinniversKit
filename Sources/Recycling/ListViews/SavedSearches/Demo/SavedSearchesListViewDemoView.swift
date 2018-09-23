//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class SavedSearchesDataSource: NSObject {
    var models = SavedSearchFactory.create(numberOfModels: 9)
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

    lazy var savedSearchesListView: SavedSearchesListView = {
        let view = SavedSearchesListView(delegate: self, dataSource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private func setup() {
        addSubview(savedSearchesListView)
        savedSearchesListView.fillInSuperview()
    }
}

extension SavedSearchesListViewDemoView: SavedSearchesListViewDelegate {
    public func savedSearchesListView(_ savedSearchesListView: SavedSearchesListView, didSelectItemAtIndex index: Int) {}

    public func savedSearchesListView(_ savedSearchesListView: SavedSearchesListView, didDeleteItemAt index: Int) {
        let old = dataSource.models
        dataSource.models.remove(at: index)
        let updated = dataSource.models

        let changes = ChangeSet(old: old, updated: updated)
        savedSearchesListView.deleteRows(at: changes.deletedRows)
    }

    public func savedSearchesListView(_ savedSearchesListView: SavedSearchesListView, didSelectSettingsAtIndex index: Int) {}
}

extension SavedSearchesListViewDemoView: SavedSearchesListViewDataSource {
    public func numberOfItems(inSavedSearchesListView savedSearchesListView: SavedSearchesListView) -> Int {
        return dataSource.models.count
    }

    public func savedSearchesListView(_ savedSearchesListView: SavedSearchesListView, modelAtIndex index: Int) -> SavedSearchesListViewModel? {
        return dataSource.models[index]
    }
}
