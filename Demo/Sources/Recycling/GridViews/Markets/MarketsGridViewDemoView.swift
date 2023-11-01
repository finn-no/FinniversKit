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
        //demoStack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 100).isActive = true


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
        print("SETTING UP FINN:", dataSource.models.count)
        titleLable.text = "Finn: \(dataSource.models.count)"
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
        print("Setting up tori", dataSource.models.count)
        var collectionView = MarketsGridView(accessibilityHeader: "Markeder", delegate: self, dataSource: self)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.isMarketGridCellLabelTwoLined = true
        
        addSubview(collectionView)

        titleLable.text = "Tori, \(dataSource.models.count)"
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

/*
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
        print("SETTING UP TORI")
        var finnCollection = FinnMarketsDemoView()
       // finnCollection.translatesAutoresizingMaskIntoConstraints = false
        addSubview(finnCollection)

        /*
        let finnCollectionView = MarketsGridView(accessibilityHeader: "Markeder", delegate: self, dataSource: self)
        finnCollectionView.translatesAutoresizingMaskIntoConstraints = false
        */

        var toriCollection = ToriMarketsDemoView()
        toriCollection.translatesAutoresizingMaskIntoConstraints = false
        //addSubview(toriCollection)

        /*
        var toriCollectionView = MarketsGridView(accessibilityHeader: "Markeder", delegate: self, dataSource: self)
        
        toriCollectionView.translatesAutoresizingMaskIntoConstraints = false
        toriCollectionView.isMarketGridCellLabelTwoLined = true*/
        

        NSLayoutConstraint.activate([

            //finnCollection.topAnchor.constraint(equalTo: topAnchor, constant: 10),
           // finnCollection.leadingAnchor.constraint(equalTo: leadingAnchor),
/*
            toriCollection.topAnchor.constraint(equalTo: finnCollection.bottomAnchor, constant: 30),
            toriCollection.leadingAnchor.constraint(equalTo: leadingAnchor)*/
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
*/
