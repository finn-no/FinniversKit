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

    private lazy var slider: UISlider = {
        let slider = UISlider(withAutoLayout: true)
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        return slider
    }()

    private let numberFormatter: NumberFormatter

    // MARK: - Initializers

    init(numberFormatter: NumberFormatter, withAutoLayout: Bool = false) {
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

    @objc private func sliderValueChanged() {
        valueLabel.text = numberFormatter.string(for: slider.value)
        delegate?.titleValueSlider(self, didChangeValue: slider.value)
    }
}
