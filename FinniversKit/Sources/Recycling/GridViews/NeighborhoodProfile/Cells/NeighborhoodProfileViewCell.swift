//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

class NeighborhoodProfileViewCell: UICollectionViewCell {
    static let titleFont = UIFont.captionStrong

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

    func makeTitleLabel() -> UILabel {
        let label = UILabel(withAutoLayout: true)
        label.font = NeighborhoodProfileViewCell.titleFont
        label.textColor = .text
        label.numberOfLines = 0
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }

    private func setup() {
        backgroundColor = .clear
        contentView.backgroundColor = .background

        contentView.layer.cornerRadius = Warp.Spacing.spacing100
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.backgroundDisabled.withAlphaComponent(0.1).cgColor

        contentView.dropShadow(color: UIColor.black.withAlphaComponent(0.2), offset: CGSize(width: 0, height: 2), radius: 5)
    }
}
