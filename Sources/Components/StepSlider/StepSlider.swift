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

    public var accentColor: UIColor? = UIColor.btnPrimary {
        didSet {
            guard let accentColor = accentColor else {
                return
            }
            activeRangeTrackView.backgroundColor = accentColor
            updateThumbImageForAccentColor()
        }
    }

    // MARK: - Private properties

    private let showTrackViews: Bool
    private let maximumValueWithoutOffset: Float
    private let leftOffset: Float
    private var previousValue: Float = 0

    private lazy var trackView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .decorationSubtle
        view.layer.cornerRadius = 1.0
        return view
    }()

    private lazy var activeRangeTrackView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .btnPrimary
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

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)

        guard
            #available(iOS 12.0, *),
            previousTraitCollection?.userInterfaceStyle != traitCollection.userInterfaceStyle
        else {
            return
        }

        updateThumbImageForAccentColor()
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

    private func updateThumbImageForAccentColor() {
        guard let accentColor = accentColor else {
            return
        }

        let imageFactory = ThumbImageFactory(
            diameter: 28,
            centerRadius: 12,
            highlightedCenterRadius: 18,
            accentColor: accentColor
        )
        setThumbImage(imageFactory.image, for: .normal)
        setThumbImage(imageFactory.highligtedImage, for: .highlighted)
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

class ThumbImageFactory {
    let accentColor: UIColor
    let diameter: CGFloat
    let centerRadius: CGFloat
    let highlightedCenterRadius: CGFloat
    let bounds: CGRect
    let shadowSize: CGFloat = 5

    init(diameter: CGFloat, centerRadius: CGFloat, highlightedCenterRadius: CGFloat, accentColor: UIColor) {
        self.diameter = diameter
        self.centerRadius = centerRadius
        self.highlightedCenterRadius = highlightedCenterRadius
        self.accentColor = accentColor
        self.bounds = CGRect(origin: .zero, size: CGSize(width: diameter, height: diameter))
    }

    var image: UIImage? {
        if _image == nil {
            _image = computeImage(effectiveRadius: centerRadius)
        }
        return _image
    }

    var highligtedImage: UIImage? {
        if _highligtedImage == nil {
            _highligtedImage = computeImage(effectiveRadius: highlightedCenterRadius)
        }
        return _highligtedImage
    }

    private var _image: UIImage?
    private var _highligtedImage: UIImage?

    private func computeImage(effectiveRadius: CGFloat) -> UIImage {
        let sizeWithShadow = CGSize(width: diameter + shadowSize * 2, height: diameter + shadowSize * 2)
        let renderer = UIGraphicsImageRenderer(size: sizeWithShadow)
        return renderer.image { (context) in
            context.cgContext.saveGState()
            context.cgContext.setShadow(
                offset: CGSize(width: 0, height: 1),
                blur: shadowSize,
                color: UIColor(white: 0.0, alpha: 0.3).cgColor
            )

            UIColor.white.setFill()
            context.cgContext.fillEllipse(in: bounds.applying(.init(translationX: shadowSize, y: shadowSize)))
            context.cgContext.restoreGState()

            self.accentColor.setFill()
            let centerCircleOrigin = bounds
                .applying(.init(translationX: shadowSize, y: shadowSize))
                .center
                .applying(CGAffineTransform(translationX: -effectiveRadius / 2.0, y: -effectiveRadius / 2.0))
            let centerSize = CGSize(width: effectiveRadius, height: effectiveRadius)
            context.cgContext.fillEllipse(in: CGRect(origin: centerCircleOrigin, size: centerSize))
        }
    }
}

private extension CGRect {
    var center: CGPoint {
        CGPoint(x: origin.x + width / 2.0, y: origin.y + height / 2.0)
    }
}
