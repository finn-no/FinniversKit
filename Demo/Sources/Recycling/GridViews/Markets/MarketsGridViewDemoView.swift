//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit
import UIKit

class MarketDataSource: NSObject {
    var models = Market.newMarkets
}
class ToriDataSource: NSObject {
    var models = Market.toriMarkets
}

class MarketsGridViewDemoView: UIView, Demoable {
    lazy var dataSource: MarketDataSource = {
        return MarketDataSource()
    }()
    

    var toriLabel = UILabel()
    var finnLabel = UILabel()

    var showingTori = false

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let finnCollectionView = MarketsGridView(accessibilityHeader: "Markeder", delegate: self, dataSource: self)
        finnCollectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(finnCollectionView)

        let toriCollectionView = MarketsGridView(accessibilityHeader: "Markeder", delegate: self, dataSource: self)
        toriCollectionView.translatesAutoresizingMaskIntoConstraints = false
        toriCollectionView.isMarketGridCellLabelTwoLined = true
        
        addSubview(toriCollectionView)
        


        finnLabel.text = "Finn"
        finnLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        finnLabel.textAlignment = .center
        finnLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(finnLabel)

        toriLabel.text = "Tori"
        toriLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        toriLabel.textAlignment = .center
        toriLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(toriLabel)

        NSLayoutConstraint.activate([
            finnLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            finnLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            finnCollectionView.topAnchor.constraint(equalTo: finnLabel.bottomAnchor, constant: 10),
            finnCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            finnCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            finnCollectionView.heightAnchor.constraint(equalToConstant: finnCollectionView.calculateSize(constrainedTo: frame.width).height),

            toriLabel.topAnchor.constraint(equalTo: finnCollectionView.bottomAnchor, constant: 30),
            toriLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            toriCollectionView.topAnchor.constraint(equalTo: toriLabel.bottomAnchor, constant: 10),
            toriCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            toriCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            toriCollectionView.heightAnchor.constraint(equalToConstant: finnCollectionView.calculateSize(constrainedTo: frame.width).height + 35)
        ])
    }
}

extension MarketsGridViewDemoView: MarketsViewDataSource {
    func numberOfItems(inMarketsView marketsView: MarketsView) -> Int {
        return dataSource.models.count
    }

    func marketsView(_ marketsView: MarketsView, modelAtIndex index: Int) -> MarketsViewModel {
        return dataSource.models[index]
    }
}

extension MarketsGridViewDemoView: MarketsViewDelegate {
    func marketsView(_ marketsGridView: MarketsView, didSelectItemAtIndex index: Int) {}
}
