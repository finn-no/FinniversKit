//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol AdConfirmationViewDelegate: AnyObject {
    func adConfirmationView( _ : AdConfirmationView, didTapActionButton button: UIButton)
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

    private lazy var completeButton: FooterButtonView = {
        let button = FooterButtonView(withAutoLayout: true)
        button.delegate = self
        return button
    }()

    public weak var delegate: AdConfirmationViewDelegate?

    public var model: AdConfirmationViewModel? {
        didSet {
            confirmationObjectView.model = model?.objectViewModel
            completeButton.buttonTitle = model?.completeButtonText

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
        addSubview(completeButton)
        NSLayoutConstraint.activate([
            completeButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            completeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            completeButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: completeButton.topAnchor)
        ])

        scrollView.addSubview(contentView)
        contentView.addSubview(confirmationObjectView)

        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            confirmationObjectView.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 200),
            confirmationObjectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            confirmationObjectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }

    func setupSummaryView() {
        if let summaryViewModel = model?.summaryViewModel, summaryViewModel.orderLines.count > 0 {
            let summaryView = AdConfirmationSummaryView(model: summaryViewModel, withAutoLayout: true)
            contentView.addSubview(summaryView)

            let heightForTitleLabel = CGFloat(summaryView.titleLabelHeight)
            let heightForOrderLinesView = (CGFloat(summaryViewModel.orderLines.count) * summaryView.checkmarkViewHeight)
            let heightForPriceStackView = CGFloat(72)
            let summaryViewHeightConstant = CGFloat(heightForTitleLabel + heightForOrderLinesView + heightForPriceStackView)

            NSLayoutConstraint.activate([
                summaryView.topAnchor.constraint(equalTo: confirmationObjectView.bottomAnchor, constant: .mediumSpacing),
                summaryView.heightAnchor.constraint(equalToConstant: summaryViewHeightConstant),
                summaryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
                summaryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

                confirmationObjectView.topAnchor.constraint(equalTo: contentView.topAnchor),
                contentView.bottomAnchor.constraint(greaterThanOrEqualTo: summaryView.bottomAnchor),
            ])
        } else {
            confirmationObjectView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: bottomAnchor).isActive = true
        }
    }
}

extension AdConfirmationView: FooterButtonViewDelegate {
    public func footerButtonView(_ view: FooterButtonView, didSelectButton button: UIButton) {
        delegate?.adConfirmationView(self, didTapActionButton: button)
    }
}
