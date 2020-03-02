//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public protocol TransactionViewDelegate: AnyObject {
    func transactionViewDidBeginRefreshing(_ refreshControl: RefreshControl)
    func transactionViewDidSelectPrimaryButton(_ view: TransactionView, inTransactionStep step: Int,
                                               withAction action: TransactionStepView.PrimaryButton.Action, withUrl urlString: String?,
                                               withFallbackUrl fallbackUrlString: String?)
}

public protocol TransactionViewDataSource: AnyObject {
    func transactionViewModelForIndex(_ view: TransactionView, forStep step: Int) -> TransactionStepViewModel
    func transactionViewNumberOfSteps(_ view: TransactionView) -> Int
    func transactionViewCurrentStep(_ view: TransactionView) -> Int
}

public class TransactionView: UIView {

    // MARK: - Properties

    private var model: TransactionViewModel?
    private weak var dataSource: TransactionViewDataSource?
    private weak var delegate: TransactionViewDelegate?

    private var numberOfSteps: Int = 0
    private var currentStep: Int = 0

    private var stepDots = [TransactionStepDot]()
    private var connectors = [TransactionStepDotConnector]()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = RefreshControl(frame: .zero)
        refreshControl.delegate = self
        return refreshControl
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.alwaysBounceVertical = true
        scrollView.refreshControl = refreshControl
        return scrollView
    }()

    private lazy var scrollableContentView: UIView = UIView(withAutoLayout: true)
    private lazy var titleLabel: Label = Label(style: .title1, withAutoLayout: true)

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = .spacingM
        return stackView
    }()

    private var verticalStackViewTopAnchor: NSLayoutConstraint?

    // MARK: - Init

    public init(withAutoLayout autoLayout: Bool = true, model: TransactionViewModel,
                dataSource: TransactionViewDataSource, delegate: TransactionViewDelegate) {

        self.model = model
        self.dataSource = dataSource
        self.delegate = delegate

        super.init(frame: .zero)

        self.numberOfSteps = dataSource.transactionViewNumberOfSteps(self)
        self.currentStep = dataSource.transactionViewCurrentStep(self)

        titleLabel.text = model.title
        translatesAutoresizingMaskIntoConstraints = !autoLayout

        setup()
        progressTo(currentStep)
    }

    public required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

// MARK: - Private

private extension TransactionView {
    func setup() {
        backgroundColor = .bgPrimary

        addSubview(scrollView)
        scrollView.addSubview(scrollableContentView)

        scrollableContentView.fillInSuperview()
        scrollableContentView.addSubview(titleLabel)
        scrollableContentView.addSubview(verticalStackView)

        if let warningViewModel = model?.warning {
            let warningView = TransactionWarningView( withAutoLayout: true, model: warningViewModel)
            scrollableContentView.addSubview(warningView)

            NSLayoutConstraint.activate([
                warningView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .spacingM),
                warningView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -.spacingM),
                warningView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingS),
            ])

            verticalStackViewTopAnchor = verticalStackView.topAnchor.constraint(equalTo: warningView.bottomAnchor, constant: .spacingXL)

        } else {
            verticalStackViewTopAnchor = verticalStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingXL)
        }

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            scrollableContentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor, constant: .spacingS),
            scrollableContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .spacingXL),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),

            verticalStackView.trailingAnchor.constraint(equalTo: scrollableContentView.trailingAnchor, constant: -.spacingXL),
            verticalStackViewTopAnchor!,
            verticalStackView.bottomAnchor.constraint(equalTo: scrollableContentView.bottomAnchor),
        ])

        for index in 0..<numberOfSteps {
            guard let model = dataSource?.transactionViewModelForIndex(self, forStep: index) else { return }

            addTransactionStepView(index, model)
            addTransactionStepDot(index)
        }

        guard let stepDot = stepDots.first else { return }
        NSLayoutConstraint.activate([verticalStackView.leadingAnchor.constraint(equalTo: stepDot.trailingAnchor, constant: .spacingS)])
    }

    private func addTransactionStepView(_ step: Int, _ model: TransactionStepViewModel) {
        let transactionStepView = TransactionStepView(step: step, model: model, withAutoLayout: true)
        transactionStepView.delegate = self

        if step == numberOfSteps - 1 && model.state == .completed {
            transactionStepView.hasCompletedLastStep(true)
        }

        verticalStackView.addArrangedSubview(transactionStepView)
    }

    private func addTransactionStepDot(_ step: Int) {
        let stepDot = TransactionStepDot(step: step)
        stepDots.append(stepDot)

        guard let currentStepView = verticalStackView.arrangedSubviews[safe: step] as? TransactionStepView else { return }

        scrollableContentView.addSubview(stepDot)
        NSLayoutConstraint.activate([
            stepDot.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            stepDot.topAnchor.constraint(equalTo: currentStepView.topAnchor),
        ])

        guard let previousStepDot = stepDots[safe: step - 1] else { return }
        let connector = TransactionStepDotConnector(withAutoLayout: true)
        connectors.append(connector)

        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.addArrangedSubview(connector)

        scrollableContentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: stepDot.centerXAnchor),
            stackView.topAnchor.constraint(equalTo: previousStepDot.bottomAnchor),
            stackView.bottomAnchor.constraint(equalTo: currentStepView.topAnchor)
        ])

        connector.connect(from: stepDot, to: previousStepDot)
    }

    func progressTo(_ step: Int) {
        for index in 0..<currentStep {
            stepDots[safe: index]?.setState(.completed)
            connectors[safe: index]?.highlighted = true
        }

        stepDots[safe: currentStep]?.setState(.inProgress)
        stepDots[safe: currentStep]?.setState(.inProgress)
    }
}

// MARK: - TransactionStepViewDelegate

extension TransactionView: TransactionStepViewDelegate {
    public func transactionStepViewDidTapPrimaryButton(_ view: TransactionStepView, inTransactionStep step: Int,
                                                       withAction action: TransactionStepView.PrimaryButton.Action, withUrl urlString: String?,
                                                       withFallbackUrl fallbackUrlString: String?) {
        delegate?.transactionViewDidSelectPrimaryButton(self, inTransactionStep: step, withAction: action, withUrl: urlString, withFallbackUrl: fallbackUrlString)
    }
}

// MARK: - RefreshControlDelegate

extension TransactionView: RefreshControlDelegate {
    public func refreshControlDidBeginRefreshing(_ refreshControl: RefreshControl) {
        delegate?.transactionViewDidBeginRefreshing(refreshControl)
    }
}
