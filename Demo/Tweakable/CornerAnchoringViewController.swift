import FinniversKit

protocol CornerAnchoringViewDelegate: AnyObject {
    func cornerAnchoringViewDidSelectTweakButton(_ cornerAnchoringView: CornerAnchoringView)
}

class CornerAnchoringView: UIView {
    weak var delegate: CornerAnchoringViewDelegate?

    private lazy var anchoredView: EasterEggButton = {
        let button = EasterEggButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .primaryBlue
        button.setImage(UIImage(named: .wrench).withRenderingMode(.alwaysTemplate), for: .normal)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(tweakButtonAction), for: .touchUpInside)
        return button
    }()

    private var anchorAreaViews = [UIView]()

    private let panRecognizer = UIPanGestureRecognizer()

    private var anchorPositions: [CGPoint] {
        return anchorAreaViews.map { $0.center }
    }

    private var initialOffset: CGPoint = .zero

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        let topLeftView = addAnchorAreaView()
        topLeftView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing).isActive = true
        topLeftView.topAnchor.constraint(equalTo: compatibleTopAnchor, constant: .mediumLargeSpacing).isActive = true

        let topRightView = addAnchorAreaView()
        topRightView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing).isActive = true
        topRightView.topAnchor.constraint(equalTo: compatibleTopAnchor, constant: .mediumLargeSpacing).isActive = true

        let bottomLeftView = addAnchorAreaView()
        bottomLeftView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing).isActive = true
        bottomLeftView.bottomAnchor.constraint(equalTo: compatibleBottomAnchor, constant: -.mediumLargeSpacing).isActive = true

        let bottomRightView = addAnchorAreaView()
        bottomRightView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing).isActive = true
        bottomRightView.bottomAnchor.constraint(equalTo: compatibleBottomAnchor, constant: -.mediumLargeSpacing).isActive = true

        addSubview(anchoredView)
        anchoredView.widthAnchor.constraint(equalToConstant: .veryLargeSpacing).isActive = true
        anchoredView.heightAnchor.constraint(equalToConstant: .veryLargeSpacing).isActive = true

        panRecognizer.addTarget(self, action: #selector(anchoredViewPanned(recognizer:)))
        anchoredView.addGestureRecognizer(panRecognizer)

    }

    override func layoutSubviews() {
        super.layoutSubviews()

        anchoredView.center = anchorPositions.last ?? .zero
    }

    private func addAnchorAreaView() -> UIView {
        let view = UIView()
        addSubview(view)
        anchorAreaViews.append(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: .veryLargeSpacing).isActive = true
        view.heightAnchor.constraint(equalToConstant: .veryLargeSpacing).isActive = true
        return view
    }

    @objc private func anchoredViewPanned(recognizer: UIPanGestureRecognizer) {
        let touchPoint = recognizer.location(in: self)
        switch recognizer.state {
        case .began:
            initialOffset = CGPoint(x: touchPoint.x - anchoredView.center.x, y: touchPoint.y - anchoredView.center.y)
        case .changed:
            anchoredView.center = CGPoint(x: touchPoint.x - initialOffset.x, y: touchPoint.y - initialOffset.y)
        case .ended, .cancelled:
            let decelerationRate = UIScrollView.DecelerationRate.normal.rawValue
            let velocity = recognizer.velocity(in: self)
            let projectedPosition = CGPoint(
                x: anchoredView.center.x + project(initialVelocity: velocity.x, decelerationRate: decelerationRate),
                y: anchoredView.center.y + project(initialVelocity: velocity.y, decelerationRate: decelerationRate)
            )
            let nearestCornerPosition = nearestCorner(to: projectedPosition)
            let relativeInitialVelocity = CGVector(
                dx: relativeVelocity(forVelocity: velocity.x, from: anchoredView.center.x, to: nearestCornerPosition.x),
                dy: relativeVelocity(forVelocity: velocity.y, from: anchoredView.center.y, to: nearestCornerPosition.y)
            )
            let timingParameters = UISpringTimingParameters(damping: 1, response: 0.4, initialVelocity: relativeInitialVelocity)
            let animator = UIViewPropertyAnimator(duration: 0, timingParameters: timingParameters)
            animator.addAnimations {
                self.anchoredView.center = nearestCornerPosition
            }
            animator.startAnimation()
        default: break
        }
    }

    /// Distance traveled after decelerating to zero velocity at a constant rate.
    private func project(initialVelocity: CGFloat, decelerationRate: CGFloat) -> CGFloat {
        return (initialVelocity / 1000) * decelerationRate / (1 - decelerationRate)
    }

    /// Finds the position of the nearest corner to the given point.
    private func nearestCorner(to point: CGPoint) -> CGPoint {
        var minDistance = CGFloat.greatestFiniteMagnitude
        var closestPosition = CGPoint.zero
        for position in anchorPositions {
            let distance = point.distance(to: position)
            if distance < minDistance {
                closestPosition = position
                minDistance = distance
            }
        }
        return closestPosition
    }

    /// Calculates the relative velocity needed for the initial velocity of the animation.
    private func relativeVelocity(forVelocity velocity: CGFloat, from currentValue: CGFloat, to targetValue: CGFloat) -> CGFloat {
        guard currentValue - targetValue != 0 else { return 0 }
        return velocity / (targetValue - currentValue)
    }

    /// Forwards all touches not applied to subviews.
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return subviews.contains(where: {
            !$0.isHidden && $0.point(inside: self.convert(point, to: $0), with: event)
        })
    }

    @objc private func tweakButtonAction() {
        delegate?.cornerAnchoringViewDidSelectTweakButton(self)
    }
}

extension UISpringTimingParameters {

    /// A design-friendly way to create a spring timing curve.
    ///
    /// - Parameters:
    ///   - damping: The 'bounciness' of the animation. Value must be between 0 and 1.
    ///   - response: The 'speed' of the animation.
    ///   - initialVelocity: The vector describing the starting motion of the property. Optional, default is `.zero`.
    public convenience init(damping: CGFloat, response: CGFloat, initialVelocity: CGVector = .zero) {
        let stiffness = pow(2 * .pi / response, 2)
        let damp = 4 * .pi * damping / response
        self.init(mass: 1, stiffness: stiffness, damping: damp, initialVelocity: initialVelocity)
    }

}

extension CGPoint {

    /// Calculates the distance between two points in 2D space.
    /// + returns: The distance from this point to the given point.
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(point.x - self.x, 2) + pow(point.y - self.y, 2))
    }

}
