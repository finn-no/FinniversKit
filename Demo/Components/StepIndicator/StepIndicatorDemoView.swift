//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import FinniversKit

class StepIndicatorDemoView: UIView {

    // MARK: - Private properties

    private var numberOfSteps = 4
    private var stepIndicator: StepIndicator?
    private var currentStep = 0

    // MARK: - UI properties

    private lazy var numberOfStepsLabel: Label = {
        let label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Number of steps"
        return label
    }()

    private lazy var numberOfStepsStepper: UIStepper = {
        let stepper = UIStepper(withAutoLayout: true)
        stepper.minimumValue = 2
        stepper.maximumValue = 10
        stepper.value = Double(numberOfSteps)
        stepper.addTarget(self, action: #selector(numberOfStepsChanged), for: .valueChanged)
        return stepper
    }()

    private lazy var currentStepLabel: Label = {
        let label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Current step"
        return label
    }()

    private lazy var currentStepStepper: UIStepper = {
        let stepper = UIStepper(withAutoLayout: true)
        stepper.minimumValue = 0
        stepper.maximumValue = Double(numberOfSteps - 1)
        stepper.value = 0
        stepper.addTarget(self, action: #selector(currentStepChanged), for: .valueChanged)
        return stepper
    }()

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        createStepIndicator()

        addSubview(numberOfStepsStepper)
        addSubview(numberOfStepsLabel)

        addSubview(currentStepStepper)
        addSubview(currentStepLabel)

        NSLayoutConstraint.activate([
            numberOfStepsStepper.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.mediumLargeSpacing),
            numberOfStepsStepper.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -.veryLargeSpacing * 2),

            numberOfStepsLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .mediumLargeSpacing),
            numberOfStepsLabel.centerYAnchor.constraint(equalTo: numberOfStepsStepper.centerYAnchor),
            numberOfStepsLabel.trailingAnchor.constraint(equalTo: numberOfStepsStepper.leadingAnchor, constant: -.mediumSpacing),

            currentStepStepper.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.mediumLargeSpacing),
            currentStepStepper.bottomAnchor.constraint(equalTo: numberOfStepsStepper.topAnchor, constant: -.mediumLargeSpacing),

            currentStepLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .mediumLargeSpacing),
            currentStepLabel.centerYAnchor.constraint(equalTo: currentStepStepper.centerYAnchor),
            currentStepLabel.trailingAnchor.constraint(equalTo: currentStepStepper.leadingAnchor, constant: -.mediumSpacing)
        ])
    }

    private func createStepIndicator() {
        currentStepStepper.value = 0
        currentStepStepper.maximumValue = Double(numberOfSteps - 1)

        stepIndicator?.removeFromSuperview()
        stepIndicator = StepIndicator(steps: numberOfSteps)

        let indicator = stepIndicator!
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.delegate = self
        addSubview(indicator)

        NSLayoutConstraint.activate([
            indicator.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .mediumLargeSpacing),
            indicator.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .mediumLargeSpacing),
            indicator.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.mediumLargeSpacing),
            indicator.heightAnchor.constraint(equalToConstant: 100.0)
        ])
    }

    // MARK: - Callbacks

    @objc private func numberOfStepsChanged() {
        numberOfSteps = Int(numberOfStepsStepper.value)
        createStepIndicator()
    }

    @objc private func currentStepChanged() {
        guard let indicator = stepIndicator else { return }
        indicator.currentStep = Int(currentStepStepper.value)
    }
}

extension StepIndicatorDemoView: StepIndicatorDelegate {
    func stepIndicator(_ stepIndicator: StepIndicator, stepTappedAtIndex index: Int) {
        currentStepStepper.value = Double(index)
        stepIndicator.currentStep = index
    }
}
