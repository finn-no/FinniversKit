//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol StepSliderDelegate: AnyObject {
    func stepSlider(_ stepSlider: StepSlider, didChangeRawValue value: Float)
    func stepSlider(_ stepSlider: StepSlider, canChangeToStep step: Step) -> Bool
    func stepSlider(_ stepSlider: StepSlider, didChangeStep step: Step)
    func stepSlider(_ stepSlider: StepSlider, didEndSlideInteraction step: Step)
    func stepSlider(_ stepSlider: StepSlider, accessibilityValueForStep step: Step) -> String
}

public final class StepSlider: UISlider {
    public weak var delegate: StepSliderDelegate?
    public var generatesHapticFeedbackOnValueChange = true
    public private(set) var step: Step

    public var currentTrackRect: CGRect {
        return trackRect(forBounds: bounds)
    }

    public var currentThumbRect: CGRect {
        return thumbRect(forBounds: bounds, trackRect: currentTrackRect, value: value)
    }

    // MARK: - Private properties

    private let showTrackViews: Bool
    private let maximumValueWithoutOffset: Float
    private let leftOffset: Float
    private var previousValue: Float = 0

    private lazy var trackView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .sardine
        view.layer.cornerRadius = 1.0
        return view
    }()

    private lazy var activeRangeTrackView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .primaryBlue
        return view
    }()

    private lazy var activeTrackViewTrailingConstraint = activeRangeTrackView.trailingAnchor.constraint(
        equalTo: trackView.trailingAnchor
    )

    // MARK: - Init

    public init(numberOfSteps: Int, hasLeftOffset: Bool = false, hasRightOffset: Bool = false, showTrackViews: Bool = false) {
        self.showTrackViews = showTrackViews
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

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateActiveTrackRange()
    }

    // MARK: - Accessibility

    public override func accessibilityDecrement() {
        let decrement = value == maximumValue && leftOffset > 0 ? leftOffset : 1
        setValueForSlider(value - decrement, animated: false)
        sendActions(for: .valueChanged)
    }

    public override func accessibilityIncrement() {
        let increment = value == minimumValue && leftOffset > 0 ? leftOffset : 1
        setValueForSlider(value + increment, animated: false)
        sendActions(for: .valueChanged)
    }

    private func updateAccessibilityValue() {
        accessibilityValue = delegate?.stepSlider(self, accessibilityValueForStep: step)
    }

    // MARK: - Slider

    public func setStep(_ step: Step, animated: Bool) {
        self.step = step
        setValueForSlider(value(from: step), animated: animated)
    }

    public func value(from step: Step) -> Float {
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
        updateActiveTrackRange()
    }

    // MARK: - Setup

    private func setup() {
        minimumTrackTintColor = .clear
        maximumTrackTintColor = .clear

        setThumbImage(UIImage(named: .sliderThumb), for: .normal)
        setThumbImage(UIImage(named: .sliderThumbActive), for: .highlighted)

        addTarget(self, action: #selector(sliderValueChanged(sender:event:)), for: .valueChanged)

        trackView.isHidden = !showTrackViews
        activeRangeTrackView.isHidden = true

        addSubview(trackView)
        addSubview(activeRangeTrackView)

        NSLayoutConstraint.activate([
            trackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .verySmallSpacing),
            trackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.verySmallSpacing),
            trackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            trackView.heightAnchor.constraint(equalToConstant: 3),

            activeRangeTrackView.leadingAnchor.constraint(equalTo: trackView.leadingAnchor),
            activeTrackViewTrailingConstraint,
            activeRangeTrackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            activeRangeTrackView.heightAnchor.constraint(equalToConstant: 6)
        ])
    }

    private func updateActiveTrackRange() {
        guard frame != .zero && showTrackViews else {
            return
        }

        let trailingConstant = currentThumbRect.midX - trackView.bounds.width
        activeTrackViewTrailingConstraint.constant = trailingConstant

        activeRangeTrackView.layoutIfNeeded()
        activeRangeTrackView.isHidden = false
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
            updateActiveTrackRange()
            delegate?.stepSlider(self, didChangeRawValue: value)
        }

        if slideEnded {
            delegate?.stepSlider(self, didEndSlideInteraction: step)
        }
    }
}
