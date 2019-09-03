//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class StepSliderDemoView: UIView {
    private let values = [100, 200, 300, 500, 1000, 2000, 3000, 4000, 5000, 10000]

    private lazy var slider: StepSlider = {
        let slider = StepSlider(
            numberOfSteps: values.count,
            hasLeftOffset: false,
            hasRightOffset: false,
            showTrackViews: true
        )
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.delegate = self
        return slider
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(slider)

        NSLayoutConstraint.activate([
            slider.centerXAnchor.constraint(equalTo: centerXAnchor),
            slider.centerYAnchor.constraint(equalTo: centerYAnchor),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }
}

// MARK: - StepSliderDelegate

extension StepSliderDemoView: StepSliderDelegate {
    func stepSlider(_ stepSlider: StepSlider, didChangeRawValue value: Float) {
        print("Raw value changed: \(value)")
    }

    func stepSlider(_ stepSlider: StepSlider, canChangeToStep step: Step) -> Bool {
        return true
    }

    func stepSlider(_ stepSlider: StepSlider, didChangeStep step: Step) {
        if let value = values.value(for: step) {
            print("Step changed, value = \(value)")
        }
    }

    func stepSlider(_ stepSlider: StepSlider, didEndSlideInteraction step: Step) {
        if let value = values.value(for: step) {
            print("Slide interaction finished, value = \(value)")
        }
    }

    func stepSlider(_ stepSlider: StepSlider, accessibilityValueForStep step: Step) -> String {
        if let value = values.value(for: step) {
            return "\(value)"
        } else {
            return ""
        }
    }
}
