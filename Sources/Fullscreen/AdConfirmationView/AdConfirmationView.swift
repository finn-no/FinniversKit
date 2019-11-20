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

    private lazy var receiptInfoLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    public weak var delegate: AdConfirmationViewDelegate?

    public var model: AdConfirmationViewModel? {
        didSet {
            confirmationObjectView.model = model?.objectViewModel
            completeButton.buttonTitle = model?.completeButtonText
            receiptInfoLabel.text = model?.summaryViewModel?.receiptInfo

            setupSummaryView()
        }
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        backgroundColor = .bgPrimary
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
            completeButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            completeButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            completeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ])

        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
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
            contentView.addSubview(receiptInfoLabel)

            let heightForTitleLabel = CGFloat(summaryView.titleLabelHeight)
            let heightForOrderLinesView = (CGFloat(summaryViewModel.orderLines.count) * summaryView.checkmarkViewHeight)
            let heightForPriceStackView = CGFloat(72)
            let summaryViewHeightConstant = CGFloat(heightForTitleLabel + heightForOrderLinesView + heightForPriceStackView)

            NSLayoutConstraint.activate([
                summaryView.topAnchor.constraint(equalTo: confirmationObjectView.bottomAnchor, constant: 40),
                summaryView.heightAnchor.constraint(equalToConstant: summaryViewHeightConstant),
                summaryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
                summaryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

                receiptInfoLabel.topAnchor.constraint(equalTo: summaryView.bottomAnchor, constant: .mediumLargeSpacing),
                receiptInfoLabel.leadingAnchor.constraint(equalTo: summaryView.leadingAnchor),
                receiptInfoLabel.trailingAnchor.constraint(equalTo: summaryView.trailingAnchor),

                confirmationObjectView.topAnchor.constraint(equalTo: contentView.topAnchor),
                contentView.bottomAnchor.constraint(greaterThanOrEqualTo: receiptInfoLabel.bottomAnchor, constant: .mediumSpacing),
            ])
        } else {
            // Disable scrolling since we have no arbitrary sized view to show.
            scrollView.isScrollEnabled = false
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor).isActive = true
        }
    }
}

extension AdConfirmationView: FooterButtonViewDelegate {
    public func footerButtonView(_ view: FooterButtonView, didSelectButton button: UIButton) {
        delegate?.adConfirmationView(self, didTapActionButton: button)
    }
}
