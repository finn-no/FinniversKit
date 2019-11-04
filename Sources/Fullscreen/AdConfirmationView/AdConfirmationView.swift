//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public class AdConfirmationView: UIView {
    private lazy var confirmationObjectView: AdConfirmationObjectView = AdConfirmationObjectView(withAutoLayout: true)
    private lazy var actionButton: Button = Button(style: .callToAction, size: .normal, withAutoLayout: true)

    public var model: AdConfirmationViewModel? {
        didSet {
            confirmationObjectView.model = model?.objectViewModel
            actionButton.setTitle(model?.completeActionLabel, for: .normal)

            setupSummaryView()
        }
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AdConfirmationView {
    func setup() {
        addSubview(confirmationObjectView)
        addSubview(actionButton)

        NSLayoutConstraint.activate([
            confirmationObjectView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            confirmationObjectView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3),
            confirmationObjectView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            confirmationObjectView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),

            actionButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .mediumLargeSpacing),
            actionButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }

    func setupSummaryView() {
        if let summaryViewModel = model?.summaryViewModel {
            let summaryView = AdConfirmationSummaryView(model: summaryViewModel, withAutoLayout: true)

            addSubview(summaryView)

            var heightMultiplier: CGFloat = 0.0
            if let orderLineCount = model?.summaryViewModel?.orderLines.count {
                if orderLineCount == 0 { heightMultiplier = 0 }
                heightMultiplier = orderLineCount > 2 ? 0.3 : 0.2
            }

            NSLayoutConstraint.activate([
                summaryView.topAnchor.constraint(equalTo: confirmationObjectView.bottomAnchor, constant: -.largeSpacing),
                summaryView.heightAnchor.constraint(greaterThanOrEqualTo: heightAnchor, multiplier: heightMultiplier),
                summaryView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .mediumLargeSpacing),
                summaryView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.mediumLargeSpacing),

                actionButton.topAnchor.constraint(equalTo: summaryView.bottomAnchor, constant: .mediumLargeSpacing),
            ])
        } else {
            actionButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -.mediumLargeSpacing).isActive = true
        }
    }
}
