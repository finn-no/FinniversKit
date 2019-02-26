//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

final class EarthHourHeaderView: UIView {
    private(set) lazy var closeButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.tintColor = .milk
        button.setImage(UIImage(named: .close), for: .normal)
        return button
    }()

    private lazy var backgroundView = UIView(withAutoLayout: true)
    private lazy var bottomCurveView = UIView(withAutoLayout: true)

    private lazy var earthImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .earthHourEarth)
        return imageView
    }()

    private lazy var eyesImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .earthHourEyes)
        return imageView
    }()

    private lazy var heartImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .earthHourHeart)
        return imageView
    }()

    private lazy var starsImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .earthHourStars)
        return imageView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Overrides

    override func layoutSubviews() {
        super.layoutSubviews()
        addBottomCurve()
    }

    // MARK: - Setup

    func animateEarth() {
        addEarthRotationAnimation()
        addEyesBlinkingAnimation()
    }

    func animateHeart() {
        addHeartAnimation()
    }

    private func setup() {
        backgroundColor = .white
        backgroundView.backgroundColor = UIColor(r: 27, g: 64, b: 134)
        bottomCurveView.backgroundColor = backgroundView.backgroundColor

        addSubview(backgroundView)
        addSubview(bottomCurveView)
        addSubview(closeButton)
        addSubview(starsImageView)
        addSubview(heartImageView)
        addSubview(earthImageView)
        earthImageView.addSubview(eyesImageView)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: .smallSpacing * 3),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.smallSpacing * 3),
            closeButton.widthAnchor.constraint(equalToConstant: .largeSpacing),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor),

            starsImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            starsImageView.centerYAnchor.constraint(equalTo: centerYAnchor),

            heartImageView.topAnchor.constraint(equalTo: earthImageView.topAnchor, constant: .largeSpacing),
            heartImageView.centerXAnchor.constraint(equalTo: centerXAnchor),

            earthImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            earthImageView.centerYAnchor.constraint(equalTo: centerYAnchor),

            eyesImageView.centerXAnchor.constraint(equalTo: earthImageView.centerXAnchor),
            eyesImageView.centerYAnchor.constraint(equalTo: earthImageView.centerYAnchor, constant: -.mediumSpacing),

            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomCurveView.topAnchor),

            bottomCurveView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bottomCurveView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bottomCurveView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bottomCurveView.heightAnchor.constraint(equalToConstant: .veryLargeSpacing)
        ])
    }

    private func addBottomCurve() {
        let bounds = bottomCurveView.bounds
        let offset: CGFloat = bounds.width / 15
        var maskBounds = bounds

        maskBounds.size.height = bounds.size.height / 2

        let maskPath = UIBezierPath(rect: maskBounds)
        let curveBounds = CGRect(
            x: bounds.origin.x - offset / 2,
            y: bounds.origin.y,
            width: bounds.size.width + offset,
            height: bounds.size.height
        )

        let curvePath = UIBezierPath(ovalIn: curveBounds)
        maskPath.append(curvePath)

        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath

        bottomCurveView.layer.mask = maskLayer
    }

    // MARK: - Animations

    private func addEarthRotationAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        animation.fromValue = -15.radians
        animation.toValue = 15.radians
        animation.duration = 1
        animation.autoreverses = true
        animation.repeatCount = .greatestFiniteMagnitude
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        earthImageView.layer.add(animation, forKey: nil)
    }

    private func addEyesBlinkingAnimation() {
        let animation = CAKeyframeAnimation(keyPath: "hidden")
        animation.values = [false, true, false, true, false, true, false]
        animation.keyTimes = [0.0, 0.45, 0.47, 0.9, 0.92, 0.98, 1.0]
        animation.duration = 3.7
        animation.calculationMode = .discrete
        animation.repeatCount = .greatestFiniteMagnitude

        eyesImageView.layer.add(animation, forKey: nil)
    }

    private func addHeartAnimation() {
        let moveAnimation = CABasicAnimation(keyPath: "position.y")
        moveAnimation.duration = 2
        moveAnimation.byValue = -CGFloat.veryLargeSpacing
        moveAnimation.isRemovedOnCompletion = false

        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.duration = 2
        scaleAnimation.fromValue = 0
        scaleAnimation.toValue = 0.4
        scaleAnimation.isRemovedOnCompletion = false

        let animationGroup = CAAnimationGroup()
        animationGroup.duration = 6
        animationGroup.repeatCount = .greatestFiniteMagnitude
        animationGroup.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animationGroup.animations = [moveAnimation, scaleAnimation]

        heartImageView.layer.add(animationGroup, forKey: nil)
    }
}

// MARK: - Private extensions

private extension Int {
    var radians: CGFloat {
        return CGFloat(self) * .pi / 180
    }
}
