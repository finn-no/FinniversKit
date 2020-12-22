//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

final class BetaFeatureDemoView: UIView {
    private lazy var betaFeatureView: BetaFeatureView = {
        let view = BetaFeatureView(withAutoLayout: true)
        view.configure(with: viewModel)
        return view
    }()

    let viewModel = BetaFeatureViewModel(
        iconImage: UIImage(named: .betaImageSearch),
        title: "Bildesøk på Torget",
        description: "Test ut bildesøket vårt og finn lignende ting på Torget",
        firstButtonTitle: "Ta nytt bilde",
        secondButtonTitle: "Velg bilde..."
    )

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        addSubview(betaFeatureView)
        layoutMargins = UIEdgeInsets(vertical: 0, horizontal: .spacingM)
        NSLayoutConstraint.activate([
            betaFeatureView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            betaFeatureView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            betaFeatureView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            betaFeatureView.bottomAnchor.constraint(lessThanOrEqualTo: layoutMarginsGuide.bottomAnchor),
        ])
    }
}
