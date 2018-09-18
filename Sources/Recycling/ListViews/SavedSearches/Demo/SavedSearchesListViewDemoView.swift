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
        let previous = dataSource.models
        dataSource.models.remove(at: index)
        let after = dataSource.models

        let changes = ChangeSet(new: after, old: previous)

        if changes.hasInsertions || changes.hasDeletions {
            DispatchQueue.main.async {
                if #available(iOS 11.0, *) {
                    savedSearchesListView.tableView.performBatchUpdates({
                        let deleteIndexPaths = changes.deletionIndexPaths()
                        savedSearchesListView.tableView.deleteRows(at: deleteIndexPaths, with: .middle)

                        let insertIndexPaths = changes.insertionIndexPaths()
                        savedSearchesListView.tableView.insertRows(at: insertIndexPaths, with: .middle)
                    }, completion: nil)
                } else {
                    savedSearchesListView.reload()
                }
            }
        }
    }
}

extension SavedSearchesListViewDemoView: SavedSearchesListViewDataSource {
    public func numberOfItems(inSavedSearchesListView savedSearchesListView: SavedSearchesListView) -> Int {
        return dataSource.models.count
    }

    public func savedSearchesListView(_ savedSearchesListView: SavedSearchesListView, modelAtIndex index: Int) -> SavedSearchesListViewModel? {
        return dataSource.models[index]
    }
}
