//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

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

extension MarketsGridViewDemoView: MarketsViewDataSource {
    public func numberOfItems(inMarketsView marketsView: MarketsView) -> Int {
        return dataSource.models.count
    }

    public func marketsView(_ marketsView: MarketsView, modelAtIndex index: Int) -> MarketsViewModel {
        return dataSource.models[index]
    }
}

extension MarketsGridViewDemoView: MarketsViewDelegate {
    public func marketsView(_ marketsGridView: MarketsView, didSelectItemAtIndex index: Int) {}
}
