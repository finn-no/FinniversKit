//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import CoreMotion
import UIKit

public protocol EmptyViewDelegate: AnyObject {
    func emptyView(_ emptyView: EmptyView, didSelectActionButton button: Button)
    func emptyView(_ emptyView: EmptyView, didMoveObjectView view: UIView)
}

public enum EmptyViewShapeType {
    case `default`
    case christmas
    case none
}

public class EmptyView: UIView {

    // MARK: - Internal properties

    private let sizeOfTriangle = CGSize(width: 90, height: 90)
    private let sizeOfCircle = CGSize(width: 75, height: 75)
    private let sizeOfRoundedSquare = CGSize(width: 55, height: 55)
    private let sizeOfRectangle = CGSize(width: 100, height: 100)
    private let sizeOfSquare = CGSize(width: 50, height: 50)
    private let sizeOfCandyCane = CGSize(width: 30, height: 85.863)

    private var hasLayedOut = false
    private var hasSetup = false
    private let shapeType: EmptyViewShapeType

    // MARK: - Regular shapes

    private lazy var triangle: TriangleView = {
        let view = TriangleView(frame: CGRect(x: 0, y: 0, width: sizeOfTriangle.width, height: sizeOfTriangle.height))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        return view
    }()

    private lazy var circle: CircleView = {
        let view = CircleView(frame: CGRect(x: 0, y: 0, width: sizeOfCircle.width, height: sizeOfCircle.height))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        return view
    }()

    private lazy var roundedSquare: RoundedRectangleView = {
        let view = RoundedRectangleView(frame: CGRect(x: 0, y: 0, width: sizeOfRoundedSquare.width, height: sizeOfRoundedSquare.height))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        return view
    }()

    private lazy var rectangle: RectangleView = {
        let view = RectangleView(frame: CGRect(x: 0, y: 0, width: sizeOfRectangle.width, height: sizeOfRectangle.height))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        return view
    }()

    private lazy var square: RectangleView = {
        let view = RectangleView(frame: CGRect(x: 0, y: 0, width: sizeOfSquare.width, height: sizeOfSquare.height))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        view.backgroundColor = .bgCritical
        return view
    }()

    // MARK: - Christmas shapes

    private lazy var triangleGift: TriangleGiftView = {
        let view = TriangleGiftView(frame: CGRect(origin: .zero, size: sizeOfTriangle))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        return view
    }()

    private lazy var bigYellowGift: RectangleGiftView = {
        let view = RectangleGiftView(frame: CGRect(origin: .zero, size: sizeOfRectangle), image: .giftSquareYellow)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        return view
    }()

    private lazy var smallPinkGift: RectangleGiftView = {
        let view = RectangleGiftView(frame: CGRect(origin: .zero, size: sizeOfSquare), image: .giftSquarePink)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        return view
    }()

    private lazy var roundedSquareGift: RoundedRectangleGiftView = {
        let view = RoundedRectangleGiftView(frame: CGRect(origin: .zero, size: sizeOfRoundedSquare))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        return view
    }()

    private lazy var blueOrnament: ChristmasOrnamentView = {
        let view = ChristmasOrnamentView(frame: CGRect(origin: .zero, size: sizeOfCircle), ornamentColor: .blue)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        return view
    }()

    private lazy var redOrnament: ChristmasOrnamentView = {
        let view = ChristmasOrnamentView(frame: CGRect(origin: .zero, size: sizeOfSquare), ornamentColor: .red)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        return view
    }()

    private lazy var smallStarOrnament: StarView = {
        let view = StarView(frame: CGRect(origin: .zero, size: sizeOfSquare))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        return view
    }()

    private lazy var bigStarOrnament: StarView = {
        let view = StarView(frame: CGRect(origin: .zero, size: sizeOfCircle))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        return view
    }()

    private lazy var candyCane: CandyCaneView = {
        let view = CandyCaneView(frame: CGRect(origin: .zero, size: sizeOfCandyCane))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        return view
    }()

    // MARK: - Other private attributes

    private lazy var headerLabel: Label = {
        let label = Label(style: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var messageLabel: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private lazy var actionButton: Button = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(performAction), for: .touchUpInside)
        button.isHidden = true // Default is hidden. When a title is set it will be displayed.
        return button
    }()

    private lazy var animator = UIDynamicAnimator(referenceView: self)

    private lazy var gravity: UIGravityBehavior = {
        let gravity = UIGravityBehavior(items: allShapes)
        gravity.gravityDirection = CGVector(dx: 0, dy: 1.0)
        return gravity
    }()

    private lazy var collision: UICollisionBehavior = {
        let collision = UICollisionBehavior(items: allShapes)
        collision.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets(top: -10000, left: 0, bottom: 0, right: 0))
        return collision
    }()

    private lazy var itemBehavior: UIDynamicItemBehavior = {
        let itemBehavior = UIDynamicItemBehavior(items: allShapes)
        itemBehavior.elasticity = 0.5
        itemBehavior.friction = 0.3
        itemBehavior.angularResistance = 0.1
        itemBehavior.resistance = 0.1
        itemBehavior.density = 0.75
        return itemBehavior
    }()

    private lazy var motionManager: CMMotionManager = {
        let motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 1 / 60
        return motionManager
    }()

    private lazy var motionQueue = OperationQueue()

    private lazy var allShapes: [UIView] = {
        switch shapeType {
        case .default:
            return [rectangle, triangle, roundedSquare, circle, square]
        case .christmas:
            return [smallPinkGift, smallStarOrnament, triangleGift, candyCane, roundedSquareGift, blueOrnament, redOrnament, bigStarOrnament, bigYellowGift]
        case .none:
            return [UIView]()
        }
    }()

    // MARK: - External properties / Dependency injection

    public weak var delegate: EmptyViewDelegate?

    public var header: String = "" {
        didSet {
            headerLabel.text = header
            headerLabel.accessibilityLabel = header
        }
    }

    public var message: String = "" {
        didSet {
            messageLabel.text = message
            messageLabel.accessibilityLabel = message
        }
    }

    public var image: UIImage? {
        didSet {
            imageView.image = image
        }
    }

    public var actionButtonTitle: String = "" {
        didSet {
            actionButton.setTitle(actionButtonTitle, for: .normal)
            actionButton.accessibilityLabel = actionButtonTitle
            actionButton.isHidden = actionButtonTitle.isEmpty
        }
    }

    // MARK: - Init

    public init(shapeType: EmptyViewShapeType = .default) {
        self.shapeType = shapeType
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        self.shapeType = .default
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Overrides

    public override func didMoveToWindow() {
        super.didMoveToWindow()

        if window == nil {
            stopMotionManager()
            animator.removeAllBehaviors()
        } else {
            if hasLayedOut && animator.behaviors.isEmpty {
                addAnimatorBehaviors()
            }

            if hasSetup {
                startMotionManager()
            }
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        // We only want to lay out once
        guard hasLayedOut == false else {
            return
        }

        resetSubviews()
        hasLayedOut = true
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = .bgPrimary

        for shape in allShapes {
            addSubview(shape)
        }

        addSubview(headerLabel)
        addSubview(messageLabel)
        addSubview(imageView)
        addSubview(actionButton)

        startMotionManager()

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: .spacingXXL),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXL),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXL),

            messageLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: .spacingXL),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXL),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXL),

            imageView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: .spacingXL),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXL),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXL),

            actionButton.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .spacingXL),
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingXL),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingXL)
        ])

        hasSetup = true
    }

    private func resetSubviews() {
        let slice = frame.width / 8

        // We reposition the shapes after the EmptyView itself has layed out its frame.
        // At this point we will have its size even if we use constraints to lay it out.
        switch shapeType {
        case .default:
            triangle.center = CGPoint(x: slice, y: frame.height - (sizeOfTriangle.height / 2))
            circle.center = CGPoint(x: slice * 2, y: frame.height - (sizeOfCircle.height / 2))
            square.center = CGPoint(x: slice * 3, y: frame.height - (sizeOfSquare.height / 2))
            roundedSquare.center = CGPoint(x: slice * 5, y: frame.height - (sizeOfRoundedSquare.height / 2))
            rectangle.center = CGPoint(x: slice * 7, y: frame.height - (sizeOfRectangle.height / 2))
        case .christmas:
            triangleGift.center = CGPoint(x: slice, y: frame.height - (sizeOfTriangle.height / 2))
            bigStarOrnament.center = CGPoint(x: slice, y: frame.height - (sizeOfCircle.height * 1.5))
            blueOrnament.center = CGPoint(x: slice * 2.3, y: frame.height - sizeOfCircle.height)
            smallPinkGift.center = CGPoint(x: slice * 3.5, y: frame.height - (sizeOfSquare.height / 2))
            redOrnament.center = CGPoint(x: slice * 4, y: frame.height - (sizeOfSquare.height + (sizeOfSquare.height * 1.2)))
            roundedSquareGift.center = CGPoint(x: slice * 5, y: frame.height - (sizeOfRoundedSquare.height / 2))
            smallStarOrnament.center = CGPoint(x: slice * 5.5, y: frame.height - (sizeOfSquare.height * 2))
            candyCane.center = CGPoint(x: slice * 7, y: frame.height - (sizeOfCandyCane.height / 2 + sizeOfRectangle.height))
            bigYellowGift.center = CGPoint(x: slice * 7, y: frame.height - (sizeOfRectangle.height / 2))
        case .none:
            break
        }

        // We add the behaviors after laying out the subviews to avoid issues with initial positions of the shapes
        addAnimatorBehaviors()
    }

    // MARK: - Actions

    @objc func panAction(sender: UIPanGestureRecognizer) {
        guard let objectView = sender.view, var attachable = objectView as? AttachableView else {
            return
        }

        let location = sender.location(in: self)
        let touchLocation = sender.location(in: objectView)
        let touchOffset = UIOffset(horizontal: touchLocation.x - objectView.bounds.midX, vertical: touchLocation.y - objectView.bounds.midY)

        if sender.state == .began {
            let newAttach = UIAttachmentBehavior(item: objectView, offsetFromCenter: touchOffset, attachedToAnchor: location)
            animator.addBehavior(newAttach)
            attachable.attach = newAttach
        } else if sender.state == .changed {
            if let attach = attachable.attach {
                attach.anchorPoint = location
            }
        } else if sender.state == .ended {
            if let attach = attachable.attach {
                animator.removeBehavior(attach)
                itemBehavior.addLinearVelocity(sender.velocity(in: self), for: objectView)
                delegate?.emptyView(self, didMoveObjectView: objectView)
            }
        }
    }

    @objc private func performAction() {
        delegate?.emptyView(self, didSelectActionButton: actionButton)
    }
}

// MARK: - Accelerometer calculations

private extension EmptyView {
    func startMotionManager() {
        motionManager.startAccelerometerUpdates()
        motionManager.startDeviceMotionUpdates(to: motionQueue, withHandler: { [weak self] motion, error in
            if error != nil {
                return
            }

            guard let motion = motion else {
                return
            }

            let gravity: CMAcceleration = motion.gravity
            var vector = CGVector(dx: CGFloat(gravity.x), dy: CGFloat(gravity.y))

            DispatchQueue.main.async { [weak self] in
                // Correct for orientation
                guard
                    let self,
                    let windowScene = UIApplication.shared.connectedScenes.keyWindow?.windowScene
                else { return }
                let orientation = windowScene.interfaceOrientation

                switch orientation {
                case .portrait:
                    vector.dy *= -1
                case .landscapeLeft:
                    vector.dx = CGFloat(gravity.y)
                    vector.dy = CGFloat(gravity.x)
                case .landscapeRight:
                    vector.dx = CGFloat(-gravity.y)
                    vector.dy = CGFloat(-gravity.x)
                default: break
                }

                self.gravity.gravityDirection = vector
            }
        })
    }

    func stopMotionManager() {
        motionManager.stopAccelerometerUpdates()
        motionManager.stopDeviceMotionUpdates()
    }

    func addAnimatorBehaviors() {
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
        animator.addBehavior(itemBehavior)
    }
}
