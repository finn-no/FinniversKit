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
    private lazy var completeButton: Button = {
        let button = Button(style: .callToAction, size: .normal, withAutoLayout: true)
        button.addTarget(self, action: #selector(didTapActionButton(_:)), for: .touchUpInside)
        return button
    }()

    public weak var delegate: AdConfirmationViewDelegate?

    public var model: AdConfirmationViewModel? {
        didSet {
            confirmationObjectView.model = model?.objectViewModel
            completeButton.setTitle(model?.completeButtonText, for: .normal)

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
        contentView.addSubview(completeButton)

        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),

            confirmationObjectView.bottomAnchor.constraint(equalTo: contentView.topAnchor, constant: 216),
            confirmationObjectView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            confirmationObjectView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            completeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            completeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
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
                summaryView.topAnchor.constraint(equalTo: confirmationObjectView.bottomAnchor, constant: .smallSpacing),
                summaryView.heightAnchor.constraint(equalToConstant: summaryViewHeightConstant),
                summaryView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
                summaryView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
                summaryView.bottomAnchor.constraint(equalTo: completeButton.topAnchor, constant: -.largeSpacing),

                confirmationObjectView.topAnchor.constraint(equalTo: contentView.topAnchor),
                contentView.bottomAnchor.constraint(greaterThanOrEqualTo: completeButton.bottomAnchor, constant: .largeSpacing),
            ])
        } else {
            confirmationObjectView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
            completeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumLargeSpacing).isActive = true

            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: completeButton.bottomAnchor, constant: .largeSpacing).isActive = true
        }
    }
}
