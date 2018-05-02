//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import UIKit

class MarketDataSource: NSObject {
    var models = Market.allMarkets
}

public class MarketsGridViewDemoView: UIView {
    lazy var dataSource: MarketDataSource = {
        return MarketDataSource()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let collectionView = MarketsGridView(delegate: self, dataSource: self)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        collectionView.fillInSuperview()
    }
}

extension MarketsGridViewDemoView: MarketsGridViewDataSource {
    public func numberOfItems(inMarketsGridView marketsGridView: MarketsGridView) -> Int {
        return dataSource.models.count
    }

    public func marketsGridView(_ marketsGridView: MarketsGridView, modelAtIndex index: Int) -> MarketsGridViewModel {
        return dataSource.models[index]
    }
}

extension MarketsGridViewDemoView: MarketsGridViewDelegate {
    public func marketsGridView(_ marketsGridView: MarketsGridView, didSelectItemAtIndex index: Int) {}
}
