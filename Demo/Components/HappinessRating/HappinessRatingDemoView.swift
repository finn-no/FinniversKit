//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class HappinessRatingDemoView: UIView {

    // MARK: - Private properties

    private lazy var happinessRatingView = HappinessRatingView(withAutoLayout: true)

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
        addSubview(happinessRatingView)

        NSLayoutConstraint.activate([
            happinessRatingView.centerYAnchor.constraint(equalTo: centerYAnchor),
            happinessRatingView.heightAnchor.constraint(equalToConstant: 60),
            happinessRatingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            happinessRatingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing)
        ])
    }
}
