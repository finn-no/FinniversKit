//
//  Copyright © 2019 FINN AS. All rights reserved.
//
import Warp

public struct TitleValueSliderViewModel {
    public let title: String
    public let minimumValue: Int
    public let maximumValue: Int
    public let initialValue: Int

    public init(title: String, minimumValue: Int, maximumValue: Int, initialValue: Int) {
        self.title = title
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.initialValue = initialValue
    }
}

protocol TitleValueSliderDataSource: AnyObject {
    func titleValueSlider(_ view: TitleValueSlider, titleForValue: Float) -> String?
}

protocol TitleValueSliderDelegate: AnyObject {
    func titleValueSlider(_ view: TitleValueSlider, didChangeValue: Float)
    func titleValueSlider(_ view: TitleValueSlider, didEndSlideInteractionWithValue: Float)
}

class TitleValueSlider: UIView {
    weak var dataSource: TitleValueSliderDataSource?
    weak var delegate: TitleValueSliderDelegate?

    var accentColor: UIColor? {
        didSet {
            guard let accentColor = accentColor else {
                return
            }

            slider.accentColor = accentColor
            valueLabel.textColor = accentColor
        }
    }

    // MARK: - Private subviews
    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private lazy var valueLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.textColor = .textLink
        return label
    }()

    private lazy var slider: StepSlider = {
        let slider = StepSlider(numberOfSteps: numberOfSteps, showTrackViews: true)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.delegate = self
        return slider
    }()

    private var values: [Int] = []

    private let numberOfSteps: Int

    // MARK: - Initializers

    init(numberOfSteps: Int, withAutoLayout: Bool = false) {
        self.numberOfSteps = numberOfSteps
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Internal functions
    func configure(with model: TitleValueSliderViewModel) {
        titleLabel.text = model.title

        let increment: Int
        if (model.maximumValue - model.minimumValue) / numberOfSteps != 1 {
            increment = findIncrement(forModel: model)
        } else {
            increment = 1
        }

        values = (0...numberOfSteps).map { stepIndex in
            return min(model.maximumValue, max(model.minimumValue, stepIndex * increment + model.minimumValue))
        }

        slider.setStep(values.closestStep(for: model.initialValue), animated: true)
        sliderValueChanged()
    }

    // MARK: - Private functions
    private func setup() {
        addSubview(titleLabel)
        addSubview(valueLabel)
        addSubview(slider)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: -Warp.Spacing.spacing100),

            valueLabel.topAnchor.constraint(equalTo: topAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),

            slider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Warp.Spacing.spacing200),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func sliderValueChanged() {
        if let value = values.value(for: slider.step) {
            valueLabel.text = dataSource?.titleValueSlider(self, titleForValue: Float(value))
        }
    }

    /// Finds the biggest increment possible that will partition the values in the `numberOfStep` range values
    private func findIncrement(forModel model: TitleValueSliderViewModel) -> Int {
        let exactDivision = (model.maximumValue - model.minimumValue) / numberOfSteps
        if exactDivision.isMultiple(of: 1_000) {
            return exactDivision
        }

        for index in 1...100_000 {
            let proposedIncrement = 1_000 * index
            let proposedNumberOfSteps = ((model.maximumValue - model.minimumValue) / proposedIncrement)
            if proposedNumberOfSteps <= numberOfSteps {
                return proposedIncrement
            }
        }
        return 1
    }
}

extension TitleValueSlider: StepSliderDelegate {
    func stepSlider(_ stepSlider: StepSlider, didChangeStep step: Step) {
        if let value = values.value(for: step) {
            sliderValueChanged()
            delegate?.titleValueSlider(self, didChangeValue: Float(value))
        }
    }

    func stepSlider(_ stepSlider: StepSlider, canChangeToStep step: Step) -> Bool {
        return true
    }

    func stepSlider(_ stepSlider: StepSlider, didEndSlideInteraction step: Step) {
        if let value = values.value(for: step) {
            sliderValueChanged()
            delegate?.titleValueSlider(self, didEndSlideInteractionWithValue: Float(value))
        }
    }

    func stepSlider(_ stepSlider: StepSlider, accessibilityValueForStep step: Step) -> String {
        return "\(values.value(for: step) ?? 0)"
    }

    func stepSlider(_ stepSlider: StepSlider, didChangeRawValue value: Float) {}
}
