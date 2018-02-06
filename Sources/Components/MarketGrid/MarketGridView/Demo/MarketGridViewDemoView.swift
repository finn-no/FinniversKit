//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Finnivers
import UIKit

class MarketData: NSObject {
    var models = Market.allMarkets
}

extension MarketData: MarketGridViewDataSource {
    func numberOfItems(inMarketGridView marketGridView: MarketGridView) -> Int {
        return models.count
    }

    func marketGridView(_ marketGridView: MarketGridView, modelAtIndex index: Int) -> MarketGridModel {
        return models[index]
    }
}

extension MarketData: MarketGridViewDelegate {
    func didSelect(itemAtIndex index: Int, inMarketGridView gridView: MarketGridView) {
    }
}

public class MarketGridViewDemoView: UIView {
    lazy var data: MarketData = {
        return MarketData()
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let collectionView = MarketGridView(delegate: data, dataSource: data)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}
