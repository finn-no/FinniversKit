//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import UIKit

class MarketDataSource: NSObject {
    var models = Market.allMarkets
}

public class MarketListViewDemoView: UIView {
    lazy var dataSource: MarketDataSource = {
        return MarketDataSource()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let collectionView = MarketListView(delegate: self, dataSource: self)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        collectionView.fillInSuperview()
    }
}

extension MarketListViewDemoView: MarketListViewDataSource {
    public func numberOfItems(inMarketListView marketGridView: MarketListView) -> Int {
        return dataSource.models.count
    }

    public func marketGridView(_ marketGridView: MarketListView, modelAtIndex index: Int) -> MarketListViewModel {
        return dataSource.models[index]
    }
}

extension MarketListViewDemoView: MarketListViewDelegate {
    public func didSelect(itemAtIndex index: Int, inMarketListView gridView: MarketListView) {
    }
}
