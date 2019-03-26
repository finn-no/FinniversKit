//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol StepIndicatorDelegate: AnyObject {
    func stepIndicator(_ stepIndicator: StepIndicator, stepTappedAtIndex index: Int)
}

public class StepIndicator: UIView {

    // MARK: - Public properties

    public var currentStep: Int = 0 {
        didSet {
            updateCurrentStep()
        }
    }

    public weak var delegate: StepIndicatorDelegate?

    // MARK: - Internal properties

    static let animationDuration = 0.25
    static let activeColor = UIColor(r: 82, g: 188, b: 245)!
    static let inactiveColor = UIColor.sardine

    // MARK: - Private properties

    private static let stepDotDiameter: CGFloat = 27.0
    private let numberOfSteps: Int
    private let stackView = UIStackView(withAutoLayout: true)

    private var stepDots = [StepDot]()
    private var connectors = [StepDotConnector]()
    private var furthestStep: Int = 0

    // MARK: - Init

    public override init(frame: CGRect) {
        fatalError("Not implemented: init(frame:)")
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented: init(coder:)")
    }

    public init(steps: Int) {
        guard steps >= 2 else {
            fatalError("StepIndicator must have at least 2 steps")
        }

        numberOfSteps = steps
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        addSubview(stackView)
        stackView.fillInSuperview()
        stackView.distribution = .equalSpacing
        stackView.alignment = .center

        for index in 0..<numberOfSteps {
            let stepDot = StepDot(step: index, diameter: StepIndicator.stepDotDiameter)
            stepDot.delegate = self
            stackView.addArrangedSubview(stepDot)
            stepDots.append(stepDot)
        }

        for index in 1..<numberOfSteps {
            let connector = StepDotConnector()
            addSubview(connector)
            connector.connect(from: stepDots[index - 1], to: stepDots[index])

            sendSubviewToBack(connector)
            connectors.append(connector)
        }

        updateCurrentStep()
    }

    // MARK: - Private methods

    private func updateCurrentStep() {
        if currentStep < 0 {
            currentStep = 0
            return
        } else if currentStep >= numberOfSteps {
            currentStep = numberOfSteps - 1
            return
        }

        furthestStep = max(furthestStep, currentStep)

        for index in 0..<furthestStep {
            connectors[safe: index]?.highlight()
        }

        for index in 0..<numberOfSteps {
            let state: StepDot.State

            if index == currentStep {
                state = .inProgress
            } else if index == furthestStep {
                state = .peeked
            } else if index < furthestStep {
                state = .completed
            } else {
                state = .notStarted
            }

            stepDots[safe: index]?.setState(state)
        }
    }
}

extension StepIndicator: StepDotDelegate {
    func stepDotWasTapped(_ stepDot: StepDot) {
        delegate?.stepIndicator(self, stepTappedAtIndex: stepDot.stepIndex)
    }
}
