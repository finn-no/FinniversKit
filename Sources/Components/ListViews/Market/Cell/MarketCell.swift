//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class MarketCell: UICollectionViewCell {

    // MARK: - Internal properties

    private lazy var marketView: MarketView = {
        let marketView = MarketView()
        marketView.translatesAutoresizingMaskIntoConstraints = false
        return marketView
    }()

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        contentView.addSubview(marketView)
        marketView.fillInSuperview()
    }

    // MARK: - Superclass Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()
        marketView.prepareForReuse()
    }

    // MARK: - Dependency injection

    public var model: MarketListViewModel? {
        didSet {
            marketView.model = model
        }
    }
}
