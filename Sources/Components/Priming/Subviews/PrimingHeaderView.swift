//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

final class PrimingHeaderView: BottomShadowView {
    // MARK: - Internal properties

    var heading: String? {
        get { headingLabel.text }
        set { headingLabel.text = newValue }
    }

    // MARK: - Private properties

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

        let verticalSpacing = .mediumLargeSpacing + .mediumSpacing

        layoutMargins = UIEdgeInsets(
            top: verticalSpacing,
            left: .mediumLargeSpacing,
            bottom: verticalSpacing,
            right: .mediumLargeSpacing
        )

        headingLabel.fillInSuperviewLayoutMargins()
    }
}
