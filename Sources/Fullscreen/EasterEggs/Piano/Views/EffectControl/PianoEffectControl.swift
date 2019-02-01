//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit

protocol PianoEffectControlDelegate: AnyObject {
    func pianoEffectControl(_ control: PianoEffectControl, didChangeValue value: Float)
}

final class PianoEffectControl: UIView {
    weak var delegate: PianoEffectControlDelegate?

    var sliderColor: UIColor? {
        didSet {
            sliderView.trackView.backgroundColor = sliderColor
        }
    }

    private(set) var value: CGFloat = 0
    private let minimumValue: CGFloat = 0
    private let maximumValue: CGFloat = 1
    private let startAngle: CGFloat = -.pi * 5 / 4
    private var endAngle: CGFloat = .pi / 4
    private lazy var angle: CGFloat = startAngle

    private var angleRange: CGFloat {
        return endAngle - startAngle
    }

    private var valueRange: CGFloat {
        return maximumValue - minimumValue
    }

    // MARK: - Views

    private lazy var sliderView: PianoSlider = {
        let view = PianoSlider(withAutoLayout: true)
        view.backgroundColor = .clear
        return view
    }()

    private lazy var indicatorsView: PianoEffectIndicatorsView = {
        let view = PianoEffectIndicatorsView(instanceCount: 10, angleRange: angleRange)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.transform = CGAffineTransform(rotationAngle: startAngle)
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func setValue(_ newValue: CGFloat) {
        value = min(maximumValue, max(minimumValue, newValue))
        angle = (value - minimumValue) / valueRange * angleRange + startAngle
        sliderView.transform = CGAffineTransform(rotationAngle: angle)
    }

    // MARK: - Setup

    private func setup() {
        setValue(minimumValue)

        addSubview(indicatorsView)
        addSubview(sliderView)

        indicatorsView.fillInSuperview()

        NSLayoutConstraint.activate([
            sliderView.centerXAnchor.constraint(equalTo: indicatorsView.centerXAnchor),
            sliderView.centerYAnchor.constraint(equalTo: indicatorsView.centerYAnchor),
            sliderView.widthAnchor.constraint(equalTo: indicatorsView.widthAnchor, multiplier: 0.8),
            sliderView.heightAnchor.constraint(equalTo: sliderView.widthAnchor)
        ])
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        handleTouches(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        handleTouches(touches)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        handleTouches(touches)
        delegate?.pianoEffectControl(self, didChangeValue: Float(value))
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        handleTouches(touches)
        delegate?.pianoEffectControl(self, didChangeValue: Float(value))
    }

    // MARK: - Touches

    @objc private func handleTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else {
            return
        }

        let point = touch.location(in: self)
        let offset = CGPoint(x: point.x - bounds.midX, y: point.y - bounds.midY)
        let middleAngle = (2 * .pi + startAngle - endAngle) / 2 + endAngle
        var currentAngle = atan2(offset.y, offset.x)

        if currentAngle > middleAngle || currentAngle < (middleAngle - 2 * .pi) {
            currentAngle -= 2 * .pi
        }

        currentAngle = min(endAngle, max(startAngle, currentAngle))

        let value = (currentAngle - startAngle) / angleRange * valueRange + minimumValue
        setValue(value)
    }
}
