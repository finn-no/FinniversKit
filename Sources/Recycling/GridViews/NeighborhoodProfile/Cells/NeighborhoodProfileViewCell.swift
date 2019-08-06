//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

class NeighborhoodProfileViewCell: UICollectionViewCell {
    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .milk

        contentView.layer.cornerRadius = .mediumSpacing
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.sardine.withAlphaComponent(0.5).cgColor

        contentView.dropShadow(color: UIColor.black.withAlphaComponent(0.5), offset: CGSize(width: 0, height: 3), radius: 3)
    }
}

// MARK: - Extensions

extension NeighborhoodProfileViewCell {
    func makeTitleLabel() -> UILabel {
        let label = UILabel(withAutoLayout: true)
        label.font = .bodyStrong
        label.textColor = .licorice
        label.numberOfLines = 0
        return label
    }
}
