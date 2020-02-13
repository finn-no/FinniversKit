//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public class TransactionView: UIView {

    // MARK: - Properties

    private var numberOfSteps: Int
    private var currentStep = 3

    private var stepDots: [TransactionStepDot] = [TransactionStepDot]()

    private lazy var titleLabel: Label = Label(style: .title1, withAutoLayout: true)
    private lazy var scrollView: UIScrollView = UIScrollView(withAutoLayout: true)
    private lazy var scrollableContentView: UIView = UIView(withAutoLayout: true)

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = .mediumLargeSpacing
        return stackView
    }()

    // MARK: - Init

    public init(title: String, numberOfSteps steps: Int, withAutoLayout autoLayout: Bool = true) {
        guard steps > 2 else { fatalError("The number of steps has to be larger than 2") }
        self.numberOfSteps = steps

        super.init(frame: .zero)

        titleLabel.text = title
        translatesAutoresizingMaskIntoConstraints = !autoLayout

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}

public extension TransactionView {
    func progressTo(_ step: Int) {}
}

// MARK: - Private

private extension TransactionView {
    func setup() {
        addSubview(titleLabel)

        addSubview(scrollView)
        scrollView.addSubview(scrollableContentView)

        scrollableContentView.fillInSuperview()
        scrollableContentView.addSubview(verticalStackView)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .largeSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            titleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .mediumSpacing),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),

            scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumSpacing),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),

            scrollableContentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor, constant: .mediumSpacing),
            scrollableContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            verticalStackView.trailingAnchor.constraint(equalTo: scrollableContentView.trailingAnchor),
            verticalStackView.topAnchor.constraint(equalTo: scrollableContentView.topAnchor, constant: .mediumLargeSpacing),
            verticalStackView.bottomAnchor.constraint(equalTo: scrollableContentView.bottomAnchor),
        ])

        for index in 0..<numberOfSteps {
            addTransactionStepView(index)
            addTransactionStepConnector(index)
        }

        guard let stepDot = stepDots[safe: 0] else { return }
        verticalStackView.leadingAnchor.constraint(equalTo: stepDot.trailingAnchor, constant: .mediumSpacing).isActive = true
    }

    private func addTransactionStepView(_ step: Int) {
        var transactionStepView: TransactionStepView?
        var model = TransactionStepModel(title: "Title", subtitle: "Subtitle", buttonText: "Button", detail: "Info")

        if currentStep > step {
            for index in 0..<currentStep {
                let model = TransactionStepModel(title: "Title", subtitle: "Subtitle", buttonText: "Button")
                transactionStepView = TransactionStepView(step: index, model: model, style: .completed, withAutoLayout: true)
            }
        } else if step == currentStep {
            model = TransactionStepModel(title: "Title", subtitle: "Very very very very very very very Very very very very very very very Very very very very very very very long text", buttonText: "Button", detail: "Very very very very very very very Very very very very very very very Very very very very very very very long text")

            let random = Int(arc4random_uniform(10))
            if random % 2 == 0 {
                transactionStepView = TransactionStepView(step: step, model: model, style: .inProgress, withAutoLayout: true)
            } else {
                transactionStepView = TransactionStepView(step: step, model: model, style: .inProgressAwaitingOtherParty, withAutoLayout: true)
            }
        } else {
            transactionStepView = TransactionStepView(step: step, model: model, style: .notStarted, withAutoLayout: true)
        }

        guard let currentStepView = transactionStepView else { return }
        currentStepView.delegate = self
        verticalStackView.addArrangedSubview(currentStepView)
    }

    private func addTransactionStepConnector(_ step: Int) {
        let stepDot = TransactionStepDot(step: step)
        stepDots.append(stepDot)

        guard let stepView = verticalStackView.arrangedSubviews[safe: step] as? TransactionStepView else { return }

        scrollableContentView.addSubview(stepDot)
        NSLayoutConstraint.activate([
            stepDot.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            stepDot.centerYAnchor.constraint(equalTo: stepView.topAnchor),
        ])
    }
}

// MARK: - TransactionStepViewDelegate

extension TransactionView: TransactionStepViewDelegate {
    public func transactionStepViewDidSelectActionButton(_ view: TransactionStepView, inTransactionStep step: Int) {
        print("Did tap button in step: \(step)")
        currentStep += 1
    }
}
