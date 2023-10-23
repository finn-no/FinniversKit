//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit
import UIKit

class MarketDataSource: NSObject {
    var models = Market.newMarkets
}

class MarketsGridViewDemoView: UIView, Demoable {
    lazy var dataSource: MarketDataSource = {
        return MarketDataSource()
    }()
    var demoLabel = UILabel(frame:CGRect(x: 150, y: 140, width: 200, height: 21))
    var showingTori = false
    

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let collectionView = MarketsGridView(accessibilityHeader: "Markeder", delegate: self, dataSource: self)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)

        var stackView = UIStackView()
        
        demoLabel.textAlignment = .center
        demoLabel.text = "Tori"
        addSubview(demoLabel)
        
        let demoToggle = UISwitch(frame:CGRect(x: 150, y: 150, width: 0, height: 0))
        demoToggle.addTarget(self, action: #selector(self.changedDemoView(_:)), for: .valueChanged)
        addSubview(demoToggle)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: collectionView.calculateSize(constrainedTo: frame.width).height),
            
            
            
            demoToggle.centerXAnchor.constraint(equalTo: collectionView.centerXAnchor),
            demoToggle.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 10),
            
            demoLabel.bottomAnchor.constraint(equalTo: demoToggle.topAnchor, constant: 10),
            demoLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
        ])
    }
    
    @objc func changedDemoView(_ sender: UISwitch){
        print("TOGGLE TORI:", showingTori)
        if showingTori {
            demoLabel.text = "Tori"
        } else {
            demoLabel.text = "Finn"
        }
        showingTori.toggle()
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
