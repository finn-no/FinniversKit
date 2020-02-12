//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import Foundation

public class TransactionView: UIView {
    private var numberOfSteps = 5
    private var currentStep = 2

    private lazy var titleLabel: Label = Label(style: .title1, withAutoLayout: true)
    private lazy var scrollView: UIScrollView = UIScrollView(withAutoLayout: true)
    private lazy var scrollableContentView: UIView = UIView(withAutoLayout: true)

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = .mediumSpacing
        return stackView
    }()

    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public func configure() {
        titleLabel.text = "Salgsprosess"
    }
}

private extension TransactionView {
    func setup() {
        addSubview(titleLabel)

        addSubview(scrollView)
        scrollView.addSubview(scrollableContentView)

        scrollableContentView.fillInSuperview()

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
        ])

        for index in 0..<numberOfSteps {
            addTransactionStepView(index)
        }

//        transactionStepIndicator.progressTo(step: currentStep)
    }

    private func addTransactionStepView(_ step: Int) {
        var transactionStepView: TransactionStepView?
        let model = TransactionStepModel(transactionStep: step, title: "Title", detail: "Detail", buttonText: "Button", infoText: "Info")

        if currentStep > step {
            for index in 0..<currentStep {
                let model = TransactionStepModel(transactionStep: index, title: "Title", detail: "Detail", buttonText: "Button")
                transactionStepView = TransactionStepView(model: model, style: .completed, withAutoLayout: true)
            }
        } else if step == currentStep {
            let random = Int(arc4random_uniform(10))
            if random % 2 == 0 {
                transactionStepView = TransactionStepView(model: model, style: .inProgress, withAutoLayout: true)
            } else {
                transactionStepView = TransactionStepView(model: model, style: .inProgressAwaitingOtherParty, withAutoLayout: true)
            }
        } else {
            transactionStepView = TransactionStepView(model: model, style: .notStarted, withAutoLayout: true)
        }

        guard let currentStepView = transactionStepView else { return }
        currentStepView.delegate = self
        verticalStackView.addArrangedSubview(currentStepView)

        scrollableContentView.addSubview(verticalStackView)

        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: scrollableContentView.trailingAnchor),
            verticalStackView.topAnchor.constraint(equalTo: scrollableContentView.topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: scrollableContentView.bottomAnchor),
        ])
    }
}

extension TransactionView: TransactionStepViewDelegate {
    public func transactionStepViewDidSelectActionButton(_ view: TransactionStepView, inTransactionStep step: Int) {
        currentStep += 1
        print("Did tap button in step: \(step)")
    }
}
