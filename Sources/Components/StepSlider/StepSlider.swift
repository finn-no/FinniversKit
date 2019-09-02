//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

protocol StepSliderDelegate: AnyObject {
    func stepSlider(_ stepSlider: StepSlider, didChangeValue value: Float)
    func stepSlider(_ stepSlider: StepSlider, canChangeToStep step: Step) -> Bool
    func stepSlider(_ stepSlider: StepSlider, didChangeStep step: Step)
    func stepSlider(_ stepSlider: StepSlider, didEndSlideInteraction step: Step)
    func stepSlider(_ stepSlider: StepSlider, accessibilityValueForStep step: Step) -> String
}

final class StepSlider: UISlider {
    weak var delegate: StepSliderDelegate?
    var generatesHapticFeedbackOnValueChange = true

    private(set) var step: Step
    private var previousValue: Float = 0
    private let maximumValueWithoutOffset: Float
    private let leftOffset: Float

    var currentTrackRect: CGRect {
        return trackRect(forBounds: bounds)
    }

    var currentThumbRect: CGRect {
        return thumbRect(forBounds: bounds, trackRect: currentTrackRect, value: value)
    }

    // MARK: - Init

    init(numberOfSteps: Int, hasLeftOffset: Bool = false, hasRightOffset: Bool = false) {
        maximumValueWithoutOffset = Float(numberOfSteps)
        step = hasLeftOffset ? .lowerBound : .value(index: 0, rounded: false)

        let sideOffset = maximumValueWithoutOffset * 0.05
        let rightOffset = hasRightOffset ? sideOffset : 0
        leftOffset = hasLeftOffset ? sideOffset : 0

        super.init(frame: .zero)

        minimumValue = 0
        maximumValue = maximumValueWithoutOffset + leftOffset + rightOffset
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Accessibility

    override func accessibilityDecrement() {
        let decrement = value == maximumValue && leftOffset > 0 ? leftOffset : 1
        setValueForSlider(value - decrement, animated: false)
        sendActions(for: .valueChanged)
    }

    override func accessibilityIncrement() {
        let increment = value == minimumValue && leftOffset > 0 ? leftOffset : 1
        setValueForSlider(value + increment, animated: false)
        sendActions(for: .valueChanged)
    }

    private func updateAccessibilityValue() {
        accessibilityValue = delegate?.stepSlider(self, accessibilityValueForStep: step)
    }

    // MARK: - Setup

    private func setup() {
        minimumTrackTintColor = .clear
        maximumTrackTintColor = .clear

        setThumbImage(UIImage(named: .sliderThumb), for: .normal)
        setThumbImage(UIImage(named: .sliderThumbActive), for: .highlighted)

        addTarget(self, action: #selector(sliderValueChanged(sender:event:)), for: .valueChanged)
    }

    // MARK: - Slider

    func setStep(_ step: Step, animated: Bool) {
        self.step = step
        setValueForSlider(value(from: step), animated: animated)
    }

    func value(from step: Step) -> Float {
        switch step {
        case let .value(index, rounded):
            return Float(index) + leftOffset + (rounded ? 0.5 : 0)
        case .lowerBound:
            return minimumValue
        case .upperBound:
            return maximumValue
        }
    }

    private func step(from value: Float) -> Step {
        let valueWithoutOffset = value - leftOffset
        let index = Int(roundf(valueWithoutOffset))

        if valueWithoutOffset < minimumValue {
            return .lowerBound
        } else if valueWithoutOffset > maximumValueWithoutOffset {
            return .upperBound
        } else {
            return .value(index: index, rounded: false)
        }
    }

    private func setValueForSlider(_ value: Float, animated: Bool) {
        setValue(value, animated: animated)
        updateAccessibilityValue()
    }

    // MARK: - Actions

    @objc private func sliderValueChanged(sender slider: UISlider, event: UIEvent) {
        let slideEnded = event.allTouches?.first.map { $0.phase == .ended } ?? true
        let newStep = step(from: slider.value)
        let newValue = value(from: newStep)

        guard delegate?.stepSlider(self, canChangeToStep: newStep) ?? true else {
            value = previousValue
            return
        }

        let stepChanged = step != newStep
        let valueChanged = newValue != previousValue

        value = newValue
        step = newStep
        previousValue = value

        if stepChanged {
            delegate?.stepSlider(self, didChangeStep: step)
            if generatesHapticFeedbackOnValueChange {
                UISelectionFeedbackGenerator().selectionChanged()
            }
        }

        if valueChanged {
            updateAccessibilityValue()
            delegate?.stepSlider(self, didChangeValue: value)
        }

        if slideEnded {
            delegate?.stepSlider(self, didEndSlideInteraction: step)
        }
    }
}
