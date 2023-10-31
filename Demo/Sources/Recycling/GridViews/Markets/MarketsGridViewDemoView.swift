//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit
import UIKit

class MarketsDemoView: UIView, Demoable {
    
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
        let stackView = UIStackView()
        stackView.spacing = 20
        stackView.axis = .vertical
        stackView.addArrangedSubviews([finnDemo, toriDemo])
        
        addSubview(stackView)
        
        /*
        finnDemo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            finnDemo.topAnchor.constraint(equalTo: topAnchor),
            finnDemo.heightAnchor.constraint(equalToConstant: 100)
        ])*/
        
    }

}

class FinnDataSource: NSObject {
    var models = FinnMarket.newMarkets
}
class ToriDataSource: NSObject {
    var models = ToriMarket.toriMarkets
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
        print("SETTING UP FINN")
        titleLable.text = "Finn"
        titleLable.font = UIFont.boldSystemFont(ofSize: 16.0)
        titleLable.textAlignment = .center
        titleLable.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLable)

        var collectionView = MarketsGridView(accessibilityHeader: "Markeder", delegate: self, dataSource: self)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isMarketGridCellLabelTwoLined = true
        
        addSubview(collectionView)
        
        
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

class ToriMarketsDemoView: UIView, Demoable, MarketsViewDataSource, MarketsViewDelegate {
    lazy var dataSource: ToriDataSource = {
        return ToriDataSource()
    }()

    var titleLable = UILabel()

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

class MarketsGridViewDemoView: UIView, Demoable {
    lazy var finnDataSource: FinnDataSource = {
        return FinnDataSource()
    }()
    lazy var toriDatSource: ToriDataSource = {
        return ToriDataSource()
    }()
    
    var isFinn: Bool = false

    var toriLabel = UILabel()
    var finnLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let finnCollectionView = MarketsGridView(accessibilityHeader: "Markeder", delegate: self, dataSource: self)
        finnCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(finnCollectionView)

        var toriCollectionView = MarketsGridView(accessibilityHeader: "Markeder", delegate: self, dataSource: self)
        
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
        if isFinn {
            return finnDataSource.models.count
        } else {
            return toriDatSource.models.count
        }
    }

    func marketsView(_ marketsView: MarketsView, modelAtIndex index: Int) -> MarketsViewModel {
        if isFinn {
            return finnDataSource.models[index]
        } else {
            return toriDatSource.models[index]
        }
        
    }
}

extension MarketsGridViewDemoView: MarketsViewDelegate {
    func marketsView(_ marketsGridView: MarketsView, didSelectItemAtIndex index: Int) {}
}
