import UIKit

/// Branded replacement for UIActivityIndicatorView with possibility to use delayed start.
public class LoadingIndicatorView: UIView {
    public enum State {
        case delayedStart
        case started
        case stopped
    }
    private let backgroundLayer = CAShapeLayer()
    private let animatedLayer = CAShapeLayer()
    private let duration: CGFloat = 2.5
    private let lineWidth: CGFloat = 4
    private let startAngle: CGFloat = 3 * .pi / 2

    private var endAngle: CGFloat {
        return startAngle + 2 * .pi
    }

    public private(set) var state = State.stopped

    public var progress: CGFloat {
        get { return animatedLayer.strokeEnd }
        set {
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            animatedLayer.strokeEnd = newValue
            backgroundLayer.opacity = Float(newValue)
            CATransaction.commit()
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        let center = CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height / 2.0)
        let radius = min(bounds.size.width, bounds.size.height) / 2.0 - animatedLayer.lineWidth / 2.0

        let bezierPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)

        backgroundLayer.path = bezierPath.cgPath
        animatedLayer.path = bezierPath.cgPath
        backgroundLayer.frame = bounds
        animatedLayer.frame = bounds

        layer.addSublayer(backgroundLayer)
        layer.addSublayer(animatedLayer)
    }

    /// Starts the animation of the loading indicator after a short delay, unless it has already been stopped.
    /// - Parameters:
    ///   - after: Seconds to wait until starting animation (approximately)
    public func startAnimating(after delay: Double) {
        guard state == .stopped else { return }
        state = .delayedStart
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay) { [weak self] in
            if self?.state == .delayedStart {
                self?.startAnimating()
            }
        }
    }

    /// Starts the animation of the loading indicator.
    public func startAnimating() {
        animateGroup()
        isHidden = false
        state = .started
    }

    /// Stops the animation of the loading indicator.
    public func stopAnimating() {
        backgroundLayer.removeAllAnimations()
        animatedLayer.removeAllAnimations()
        isHidden = true
        state = .stopped
    }
}

extension LoadingIndicatorView {
    private func setup() {
        backgroundColor = .clear

        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeColor = UIColor.borderPrimary.cgColor
        backgroundLayer.strokeStart = 0
        backgroundLayer.strokeEnd = 1
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.lineCap = .round

        animatedLayer.fillColor = UIColor.clear.cgColor
        animatedLayer.strokeColor = UIColor.borderPrimarySubtle.cgColor
        animatedLayer.strokeStart = 0
        animatedLayer.strokeEnd = 1
        animatedLayer.lineWidth = lineWidth
        animatedLayer.lineCap = .round

        isHidden = true
    }

    private func animateStrokeEnd() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.beginTime = 0
        animation.duration = CFTimeInterval(duration / 2.0)
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        return animation
    }

    private func animateStrokeStart() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = CFTimeInterval(duration / 2.0)
        animation.duration = CFTimeInterval(duration / 2.0)
        animation.fromValue = 0
        animation.toValue = 1
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        return animation
    }

    private func animateRotation() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = .pi * 2.0
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = .infinity

        return animation
    }

    private func animateGroup() {
        let animationGroup = CAAnimationGroup()
        animationGroup.animations = [animateStrokeEnd(), animateStrokeStart(), animateRotation()]
        animationGroup.duration = CFTimeInterval(duration)
        animationGroup.fillMode = .both
        animationGroup.isRemovedOnCompletion = false
        animationGroup.repeatCount = .infinity

        animatedLayer.add(animationGroup, forKey: "loading")
    }
}
