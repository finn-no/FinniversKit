//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol AdConfirmationViewDelegate: AnyObject {
    func adConfirmationView( _ : AdConfirmationView, didTapActionButton button: Button)
}

public class AdConfirmationView: UIView {
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView(withAutoLayout: true)
        view.backgroundColor = .bgPrimary
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()

    private lazy var contentView: UIView = UIView(withAutoLayout: true)
    private lazy var confirmationObjectView: AdConfirmationObjectView = AdConfirmationObjectView(withAutoLayout: true)
    private lazy var actionButton: Button = {
        let button = Button(style: .callToAction, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(didTapActionButton(_:)), for: .touchUpInside)
        return button
    }()

    public weak var delegate: AdConfirmationViewDelegate?

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

    @objc func didTapActionButton(_ sender: Button) {
        delegate?.adConfirmationView(self, didTapActionButton: sender)
    }
}

private extension AdConfirmationView {
    func setup() {
        addSubview(scrollView)
        scrollView.fillInSuperview()
        scrollView.addSubview(contentView)

        contentView.addSubview(confirmationObjectView)
        contentView.addSubview(actionButton)

        NSLayoutConstraint.activate([
            // Make height of contentView larger than scrollView to allow vertical scrolling
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor, constant: 1),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            confirmationObjectView.topAnchor.constraint(equalTo: contentView.topAnchor),
            confirmationObjectView.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 216),
            confirmationObjectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            confirmationObjectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            actionButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }

    func setupSummaryView() {
        if let summaryViewModel = model?.summaryViewModel, summaryViewModel.orderLines.count > 0 {
            let summaryView = AdConfirmationSummaryView(model: summaryViewModel, withAutoLayout: true)
            contentView.addSubview(summaryView)

            let heightForTitleLabel = CGFloat(32)
            let heightForOrderLinesView = (CGFloat(summaryViewModel.orderLines.count) * 32)
            let heightForPriceStackView = CGFloat(72)
            let summaryViewHeightConstant = CGFloat(heightForTitleLabel + heightForOrderLinesView + heightForPriceStackView)

            NSLayoutConstraint.activate([
                summaryView.topAnchor.constraint(equalTo: confirmationObjectView.bottomAnchor, constant: .smallSpacing),
                summaryView.heightAnchor.constraint(equalToConstant: summaryViewHeightConstant),
                summaryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
                summaryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

                actionButton.topAnchor.constraint(equalTo: summaryView.bottomAnchor, constant: .mediumLargeSpacing),
                contentView.bottomAnchor.constraint(greaterThanOrEqualTo: actionButton.bottomAnchor, constant: .largeSpacing),
            ])
        } else {
            actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumLargeSpacing).isActive = true
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: actionButton.bottomAnchor, constant: .largeSpacing).isActive = true
        }
    }
}
