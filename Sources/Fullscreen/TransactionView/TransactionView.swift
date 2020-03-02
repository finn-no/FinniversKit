//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public protocol TransactionViewDelegate: AnyObject {
    func transactionViewDidSelectActionButton(_ view: TransactionView, inStep step: Int)
}

public protocol TransactionViewDataSource: AnyObject {
    func transactionViewModelForIndex(_ view: TransactionView, forStep step: Int) -> TransactionStepViewModel
    func transactionViewNumberOfSteps(_ view: TransactionView) -> Int
    func transactionViewCurrentStep(_ view: TransactionView) -> Int
}

public enum TransactionState {
    case notStarted
    case inProgress
    case inProgressAwaitingOtherParty
    case completed

    var style: TransactionStepView.Style {
        switch self {
        case .notStarted:
            return .notStarted
        case .inProgress:
            return .inProgress
        case .inProgressAwaitingOtherParty:
            return .inProgress
        case .completed:
            return .completed
        }
    }
}

public class TransactionView: UIView {
    // MARK: - Public

    private weak var dataSource: TransactionViewDataSource?
    private weak var delegate: TransactionViewDelegate?

    // MARK: - Properties

    private var numberOfSteps: Int = 0
    private var currentStep: Int = 0

    private var stepDots = [TransactionStepDot]()
    private var connectors = [TransactionStepDotConnector]()

    private lazy var titleLabel: Label = Label(style: .title1, withAutoLayout: true)
    private lazy var scrollView: UIScrollView = UIScrollView(withAutoLayout: true)
    private lazy var scrollableContentView: UIView = UIView(withAutoLayout: true)

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = .spacingM
        return stackView
    }()

    // MARK: - Init

    public init(title: String, dataSource: TransactionViewDataSource, delegate: TransactionViewDelegate, withAutoLayout autoLayout: Bool = true) {
        self.dataSource = dataSource
        self.delegate = delegate

        super.init(frame: .zero)

        self.numberOfSteps = dataSource.transactionViewNumberOfSteps(self)
        self.currentStep = dataSource.transactionViewCurrentStep(self)

        titleLabel.text = title
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

        addSubview(titleLabel)
        addSubview(scrollView)
        scrollView.addSubview(scrollableContentView)

        scrollableContentView.fillInSuperview()
        scrollableContentView.addSubview(verticalStackView)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .spacingXL),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .spacingS),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),

            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingS),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            scrollableContentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor, constant: .spacingS),
            scrollableContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            verticalStackView.trailingAnchor.constraint(equalTo: scrollableContentView.trailingAnchor, constant: -.spacingM),
            verticalStackView.topAnchor.constraint(equalTo: scrollableContentView.topAnchor, constant: .spacingXL),
            verticalStackView.bottomAnchor.constraint(equalTo: scrollableContentView.bottomAnchor),
        ])

        for index in 0..<numberOfSteps {
            guard let model = dataSource?.transactionViewModelForIndex(self, forStep: index) else { return }

            addTransactionStepView(index, model)
            addTransactionStepDots(index)
        }

        guard let stepDot = stepDots.first else { return }
        NSLayoutConstraint.activate([verticalStackView.leadingAnchor.constraint(equalTo: stepDot.trailingAnchor, constant: .spacingS)])
    }

    private func addTransactionStepView(_ step: Int, _ model: TransactionStepViewModel) {
        let transactionStepView = TransactionStepView(step: step, model: model, withAutoLayout: true)
        transactionStepView.delegate = self
        verticalStackView.addArrangedSubview(transactionStepView)
    }

    private func addTransactionStepDots(_ step: Int) {
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
    public func transactionStepViewDidSelectActionButton(_ view: TransactionStepView, inTransactionStep step: Int) {
        delegate?.transactionViewDidSelectActionButton(self, inStep: step)
    }
}
