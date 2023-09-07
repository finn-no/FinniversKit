//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit
import DemoKit

public class ReviewButtonViewDemoView: UIView, Demoable {
    private lazy var reviewButtonView: ReviewButtonView = {
        let view = ReviewButtonView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        view.buttonText = "Gi vurdering av kjøperen"
        return view
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        addSubview(reviewButtonView)
    }
}

extension ReviewButtonViewDemoView: ReviewButtonViewDelegate {
    public func reviewButtonView(_ reviewButtonView: ReviewButtonView, giveReviewWasTapped startReview: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.reviewButtonView.hide()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.reviewButtonView.show()
        }
    }
}
