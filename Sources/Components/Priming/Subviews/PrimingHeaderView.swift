//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

final class PrimingHeaderView: BottomShadowView {
    var heading: String? {
        get { headingLabel.text }
        set { headingLabel.text = newValue }
    }

    private let headingLabel: UILabel = {
        let label = Label(style: .title1, withAutoLayout: true)
        label.textAlignment = .center
        return label
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(headingLabel)
        layoutMargins = UIEdgeInsets(all: .mediumLargeSpacing)
        headingLabel.fillInSuperviewLayoutMargins()
    }
}
