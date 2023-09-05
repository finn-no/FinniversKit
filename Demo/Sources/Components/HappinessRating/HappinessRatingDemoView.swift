//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

class HappinessRatingDemoView: UIView, Demoable {

    var dismissKind: DismissKind { .button }

    // MARK: - Private properties

    private lazy var happinessRatingView: HappinessRatingView = {
        let view = HappinessRatingView(delegate: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        addSubview(happinessRatingView)

        NSLayoutConstraint.activate([
            happinessRatingView.centerYAnchor.constraint(equalTo: centerYAnchor),
            happinessRatingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXL),
            happinessRatingView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXL)
        ])
    }
}

extension HappinessRatingDemoView: HappinessRatingViewDelegate {
    func happinessRatingView(_ happinessRatingView: HappinessRatingView, didSelectRating rating: HappinessRating) {}

    func happinessRatingView(_ happinessRatingView: HappinessRatingView, textFor rating: HappinessRating) -> String? {
        switch rating {
        case .angry:
            return "Veldig irriterende"
        case .dissatisfied:
            return nil
        case .neutral:
            return "Nøytral"
        case .happy:
            return nil
        case .love:
            return "Veldig nyttig"
        }
    }
}
