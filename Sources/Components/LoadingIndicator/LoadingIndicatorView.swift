import UIKit

public protocol LoadingViewAnimatable {
    var alpha: CGFloat { get set }
    var transform: CGAffineTransform { get set }
    func startAnimating()
    func stopAnimating()
}

extension UIActivityIndicatorView: LoadingViewAnimatable {}

/// Branded replacement for UIActivityIndicatorView.
public class LoadingIndicatorView: UIView, LoadingViewAnimatable {
    private var backgroundLayer = CAShapeLayer()
    private var animatedLayer = CAShapeLayer()
    private var duration: CGFloat = 2.5
    private var borderColor: UIColor = .secondaryBlue
    private var backgroundLayerColor: UIColor = .sardine
    private var lineWidth: CGFloat = 4

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

        let bezierPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)

        backgroundLayer.path = bezierPath.cgPath
        animatedLayer.path = bezierPath.cgPath
        backgroundLayer.frame = bounds
        animatedLayer.frame = bounds

        layer.addSublayer(backgroundLayer)
        layer.addSublayer(animatedLayer)
    }

    /// Starts the animation of the loading indicator.
    public func startAnimating() {
        animateGroup()
        isHidden = false
    }

    /// Stops the animation of the loading indicator.
    public func stopAnimating() {
        backgroundLayer.removeAllAnimations()
        animatedLayer.removeAllAnimations()
        isHidden = true
    }
}

extension LoadingIndicatorView {
    private func setup() {
        backgroundColor = .clear

        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeColor = backgroundLayerColor.cgColor
        backgroundLayer.strokeStart = 0
        backgroundLayer.strokeEnd = 1
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.lineCap = .round

        animatedLayer.fillColor = UIColor.clear.cgColor
        animatedLayer.strokeColor = borderColor.cgColor
        animatedLayer.strokeStart = 0
        animatedLayer.strokeEnd = 1
        animatedLayer.lineWidth = lineWidth
        animatedLayer.lineCap = .round
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
