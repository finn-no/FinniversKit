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
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
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
        backgroundColor = .background
        addSubview(headingLabel)

        let verticalSpacing = .spacingM + .spacingS

        layoutMargins = UIEdgeInsets(
            top: verticalSpacing,
            left: .spacingM,
            bottom: verticalSpacing,
            right: .spacingM
        )

        headingLabel.fillInSuperviewLayoutMargins()
    }
}
