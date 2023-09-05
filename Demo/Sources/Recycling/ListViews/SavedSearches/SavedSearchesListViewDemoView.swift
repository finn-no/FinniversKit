//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

class SavedSearchesDataSource: NSObject {
    let models = SavedSearchFactory.create(numberOfModels: 9)
}

class SavedSearchesListViewDemoView: UIView, Demoable {
    lazy var dataSource: SavedSearchesDataSource = {
        return SavedSearchesDataSource()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let view = SavedSearchesListView(delegate: self, dataSource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        view.fillInSuperview()
    }
}

extension SavedSearchesListViewDemoView: SavedSearchesListViewDelegate {
    func savedSearchesListView(_ savedSearchesListView: SavedSearchesListView, didSelectItemAtIndex index: Int) {}
}

extension SavedSearchesListViewDemoView: SavedSearchesListViewDataSource {
    func numberOfItems(inSavedSearchesListView savedSearchesListView: SavedSearchesListView) -> Int {
        return dataSource.models.count
    }

    func savedSearchesListView(_ savedSearchesListView: SavedSearchesListView, modelAtIndex index: Int) -> SavedSearchesListViewModel {
        return dataSource.models[index]
    }
}
