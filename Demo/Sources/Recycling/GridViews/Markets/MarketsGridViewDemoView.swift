//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit
import UIKit

class MarketsDemoView: UIView, Demoable {
    var demoStack = UIStackView()
    var finnDemo = FinnMarketsDemoView()
    var toriDemo = ToriMarketsDemoView()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUp() {
        demoStack.translatesAutoresizingMaskIntoConstraints = false
        finnDemo.translatesAutoresizingMaskIntoConstraints = false
        toriDemo.translatesAutoresizingMaskIntoConstraints = false
        
        demoStack.axis = .vertical
        demoStack.spacing = 10.0
        demoStack.alignment = .fill
        demoStack.distribution = .fillProportionally
        demoStack.addArrangedSubviews([finnDemo, toriDemo])
        
        addSubview(demoStack)
        
        demoStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        demoStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        demoStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        demoStack.heightAnchor.constraint(equalToConstant:450).isActive = true
    }
}

class FinnDataSource: NSObject {
    var models = FinnMarket.newMarkets
}

class FinnMarketsDemoView: UIView, Demoable, MarketsViewDataSource, MarketsViewDelegate {
    lazy var dataSource: FinnDataSource = {
        return FinnDataSource()
    }()
    var titleLable = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        titleLable.text = "Finn"
        titleLable.font = UIFont.boldSystemFont(ofSize: 16.0)
        titleLable.textAlignment = .center
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLable)

        var collectionView = MarketsGridView(accessibilityHeader: "Markeder", delegate: self, dataSource: self)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isMarketGridCellLabelTwoLined = false
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            collectionView.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 166)
        ])
    }

    func numberOfItems(inMarketsView marketsView: FinniversKit.MarketsView) -> Int {
        return dataSource.models.count

    }
    func marketsView(_ marketsView: FinniversKit.MarketsView, modelAtIndex index: Int) -> FinniversKit.MarketsViewModel {
        return dataSource.models[index]

    }
    func marketsView(_ marketsGridView: FinniversKit.MarketsView, didSelectItemAtIndex index: Int) {
        print("SELECTED ITEM AT:", index)
    }
}

class ToriDataSource: NSObject {
    var models = ToriMarket.toriMarkets
}
class ToriMarketsDemoView: UIView, Demoable, MarketsViewDataSource, MarketsViewDelegate {
    lazy var dataSource: ToriDataSource = {
        return ToriDataSource()
    }()

    var titleLable = UILabel()
    var bottonLable = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() { 
        var collectionView = MarketsGridView(accessibilityHeader: "Markeder", delegate: self, dataSource: self)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isMarketGridCellLabelTwoLined = true
        
        addSubview(collectionView)

        titleLable.text = "Tori"
        titleLable.font = UIFont.boldSystemFont(ofSize: 16.0)
        titleLable.textAlignment = .center
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLable)

        NSLayoutConstraint.activate([
            titleLable.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLable.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),

            collectionView.topAnchor.constraint(equalTo: titleLable.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 200),
            
        ])
    }
    
    func numberOfItems(inMarketsView marketsView: FinniversKit.MarketsView) -> Int {
        return dataSource.models.count

    }
    func marketsView(_ marketsView: FinniversKit.MarketsView, modelAtIndex index: Int) -> FinniversKit.MarketsViewModel {
        return dataSource.models[index]

    }
    func marketsView(_ marketsGridView: FinniversKit.MarketsView, didSelectItemAtIndex index: Int) {
        print("SELECTED ITEM AT:", index)
    }
}
