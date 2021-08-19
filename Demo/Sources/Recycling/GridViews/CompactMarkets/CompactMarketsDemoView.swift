//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class CompactMarketsDemoView: UIView {
    
    lazy var demoStackView: UIStackView = {
        let sv = UIStackView(axis: .vertical, spacing: .spacingS, withAutoLayout: true)
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(demoStackView)
        NSLayoutConstraint.activate([
            demoStackView.topAnchor.constraint(equalTo: topAnchor),
            demoStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            demoStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        let oldTitle = Label(style: .title3)
        let newTitle = Label(style: .title3)
        oldTitle.textAlignment = .center
        newTitle.textAlignment = .center
        oldTitle.text = "Old design"
        newTitle.text = "New design"
        demoStackView.addArrangedSubview(oldTitle)
        addCollectionView(newDesign: false)
        demoStackView.addArrangedSubview(newTitle)
        addCollectionView(newDesign: true)
    }
    
    private func addCollectionView(newDesign: Bool) {
        let collectionView: MarketsView = newDesign ? NewCompactMarketsView(delegate: self, dataSource: self) : CompactMarketsView(delegate: self, dataSource: self)
        demoStackView.addArrangedSubview(collectionView)
        collectionView.heightAnchor.constraint(equalToConstant: collectionView.calculateSize(constrainedTo: self.frame.width).height).isActive = true
    }
}

extension CompactMarketsDemoView: MarketsViewDataSource {
    public func numberOfItems(inMarketsView marketsView: MarketsView) -> Int {
        Market.newMarkets.count
    }

    public func marketsView(_ marketsView: MarketsView, modelAtIndex index: Int) -> MarketsViewModel {
        Market.newMarkets[index]
    }
}

extension CompactMarketsDemoView: MarketsViewDelegate {
    public func marketsView(_ marketsGridView: MarketsView, didSelectItemAtIndex index: Int) {}
}
