//
//  Copyright © 2019 FINN AS. All rights reserved.
//

protocol TitleValueSliderViewModel {
    var title: String { get }
    var minimumValue: Int { get }
    var maximumValue: Int { get }
    var initialValue: Int { get }
}

protocol TitleValueSliderDelegate: AnyObject {
    func titleValueSlider(_ view: TitleValueSlider, didChangeValue: Float)
}

class TitleValueSlider: UIView {
    weak var delegate: TitleValueSliderDelegate?

    // MARK: - Private subviews
    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        return label
    }()

    private lazy var valueLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.textColor = .primaryBlue
        return label
    }()

    private lazy var slider: StepSlider = {
        let slider = StepSlider(numberOfSteps: 10_000_000, showTrackViews: true)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.delegate = self
        return slider
    }()

    private let numberFormatter: IntegerNumberSuffixFormatter

    // MARK: - Initializers

    init(numberFormatter: IntegerNumberSuffixFormatter, withAutoLayout: Bool = false) {
        self.numberFormatter = numberFormatter
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
        slider.minimumValue = Float(model.minimumValue)
        slider.maximumValue = Float(model.maximumValue)
        slider.value = Float(model.initialValue)
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
            titleLabel.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: -.mediumSpacing),

            valueLabel.topAnchor.constraint(equalTo: topAnchor),
            valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),

            slider.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumLargeSpacing),
            slider.leadingAnchor.constraint(equalTo: leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: trailingAnchor),
            slider.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func sliderValueChanged() {
        valueLabel.text = numberFormatter.string(for: slider.value)
    }
}

extension TitleValueSlider: StepSliderDelegate {
    func stepSlider(_ stepSlider: StepSlider, didChangeStep step: Step) {
        sliderValueChanged()
        delegate?.titleValueSlider(self, didChangeValue: slider.value)
    }

    func stepSlider(_ stepSlider: StepSlider, didChangeRawValue value: Float) {
    }

    func stepSlider(_ stepSlider: StepSlider, canChangeToStep step: Step) -> Bool {
        return true
    }

    func stepSlider(_ stepSlider: StepSlider, didEndSlideInteraction step: Step) {
    }

    func stepSlider(_ stepSlider: StepSlider, accessibilityValueForStep step: Step) -> String {
        return ""
    }
}
