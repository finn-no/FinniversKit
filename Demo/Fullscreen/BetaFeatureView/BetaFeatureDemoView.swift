//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class BetaFeatureDemoViewController: UIViewController {
    private lazy var betaFeatureView: BetaFeatureView = {
        let view = BetaFeatureView(withAutoLayout: true)
        view.configure(with: viewModel)
        return view
    }()

    let viewModel = BetaFeatureViewModel(
        iconImage: UIImage(named: "betaImageSearch"),
        title: "Bildesøk på Torget",
        description: "Test ut bildesøket vårt og finn lignende ting på Torget",
        firstButtonTitle: "Ta nytt bilde",
        secondButtonTitle: "Velg bilde..."
    )

    var contentSize: CGSize {
        let fittingSize = view.systemLayoutSizeFitting(
            view.bounds.size,
            withHorizontalFittingPriority: .fittingSizeLevel,
            verticalFittingPriority: .defaultLow
        )

        return CGSize(width: fittingSize.width, height: fittingSize.height + 50)
    }

    override func viewDidLoad() {
        view.addSubview(betaFeatureView)
        view.layoutMargins = UIEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
        betaFeatureView.fillInSuperviewLayoutMargins()
    }
}
