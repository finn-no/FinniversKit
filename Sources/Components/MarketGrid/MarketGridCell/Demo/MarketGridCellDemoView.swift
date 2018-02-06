//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Finnivers
import UIKit

public class MarketGridCellDemoView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let marketGridCell = MarketGridCell(frame: .zero)
        marketGridCell.translatesAutoresizingMaskIntoConstraints = false
        let model = Market.moteplassen

        let height: CGFloat = 60.0
        let width: CGFloat = 83.0

        marketGridCell.model = model
        marketGridCell.backgroundColor = .white
        addSubview(marketGridCell)

        NSLayoutConstraint.activate([
            marketGridCell.topAnchor.constraint(equalTo: topAnchor),
            marketGridCell.leadingAnchor.constraint(equalTo: leadingAnchor),
            marketGridCell.widthAnchor.constraint(equalToConstant: width),
            marketGridCell.heightAnchor.constraint(equalToConstant: height),
        ])
    }
}
