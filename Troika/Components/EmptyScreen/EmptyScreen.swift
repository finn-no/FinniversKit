//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import CoreMotion

public class EmptyScreen: UIView {

    // MARK: - Internal properties

    private let cornerRadius: CGFloat = 4.0
    private let screenSize: CGSize = UIScreen.main.bounds.size
    private let sizeOfTriangle = CGSize(width: 90, height: 90)
    private let sizeOfCircle = CGSize(width: 75, height: 75)
    private let sizeOfRoundedSquare = CGSize(width: 55, height: 55)
    private let sizeOfSquare = CGSize(width: 100, height: 100)

    private lazy var triangle: TriangleView = {
        let startingPosition = CGPoint(x: screenSize.width / 2 - sizeOfTriangle.width - sizeOfCircle.width, y: screenSize.height - sizeOfTriangle.height - 10)
        let view = TriangleView(frame: CGRect(x: startingPosition.x, y: startingPosition.y, width: sizeOfTriangle.width, height: sizeOfTriangle.height))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        return view
    }()

    private lazy var circle: CircleView = {
        let startingPosition = CGPoint(x: screenSize.width / 2 - sizeOfCircle.width - 1, y: screenSize.height - sizeOfCircle.height - 10)
        let view = CircleView(frame: CGRect(x: startingPosition.x, y: startingPosition.y, width: sizeOfCircle.width, height: sizeOfCircle.height))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        return view
    }()

    private lazy var roundedSquare: RoundedRectangleView = {
        let startingPosition = CGPoint(x: screenSize.width / 2 + 1, y: screenSize.height - sizeOfRoundedSquare.height - 10)
        let view = RoundedRectangleView(frame: CGRect(x: startingPosition.x, y: startingPosition.y, width: sizeOfRoundedSquare.width, height: sizeOfRoundedSquare.height))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        return view
    }()

    private lazy var square: UIView = {
        let startingPosition = CGPoint(x: screenSize.width / 2 + sizeOfRoundedSquare.width + 1, y: screenSize.height - sizeOfSquare.height - 10)
        let view = UIView(frame: CGRect(x: startingPosition.x, y: startingPosition.y, width: sizeOfSquare.width, height: sizeOfSquare.height))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        view.backgroundColor = .salmon
        view.layer.cornerRadius = cornerRadius
        return view
    }()

    private lazy var headerLabel: Label = {
        let label = Label(style: .title1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.textAlignment = .center
        label.numberOfLines = 2
        return label
    }()

    private lazy var messageLabel: Label = {
        let label = Label(style: .title4(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private lazy var animator: UIDynamicAnimator = {
        let animator = UIDynamicAnimator(referenceView: self)
        return animator
    }()

    private lazy var gravity: UIGravityBehavior = {
        let gravity = UIGravityBehavior(items: allSquares)
        gravity.gravityDirection = CGVector(dx: 0, dy: 1.0)
        return gravity
    }()

    private lazy var collision: UICollisionBehavior = {
        let collision = UICollisionBehavior(items: allSquares)
        collision.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsetsMake(-10000, 0, 0, 0))
        return collision
    }()

    private lazy var itemBehavior: UIDynamicItemBehavior = {
        let itemBehavior = UIDynamicItemBehavior(items: allSquares)
        itemBehavior.elasticity = 0.5
        itemBehavior.angularResistance = 0.1
        itemBehavior.resistance = 0.1
        return itemBehavior
    }()

    private lazy var motionManager: CMMotionManager = {
        let motionManager = CMMotionManager()
        motionManager.accelerometerUpdateInterval = 0.01
        return motionManager
    }()

    private lazy var motionQueue = OperationQueue()

    private lazy var allSquares: [UIView] = {
        return [square, triangle, roundedSquare, circle]
    }()

    private var attach: UIAttachmentBehavior?

    // MARK: - External properties / Dependency injection

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

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        addSubview(square)
        addSubview(triangle)
        addSubview(roundedSquare)
        addSubview(circle)

        addSubview(headerLabel)
        addSubview(messageLabel)

        // Add behaviour to animator
        animator.addBehavior(gravity)
        animator.addBehavior(collision)
        animator.addBehavior(itemBehavior)

        getAccelerometerData()
    }

    // MARK: - Superclass Overrides

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: topAnchor, constant: .veryLargeSpacing),
            headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),

            messageLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: .largeSpacing),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),
        ])
    }

    // MARK: - Actions

    @objc func panAction(sender: UIPanGestureRecognizer) {
        guard let objectView = sender.view else {
            print("\(sender) has no view")
            return
        }

        let location = sender.location(in: self)
        let touchLocation = sender.location(in: objectView)
        let touchOffset = UIOffsetMake(touchLocation.x - objectView.bounds.midX, touchLocation.y - objectView.bounds.midY)

        if sender.state == .began {
            let newAttach = UIAttachmentBehavior(item: objectView, offsetFromCenter: touchOffset, attachedToAnchor: location)
            animator.addBehavior(newAttach)
            attach = newAttach
        } else if sender.state == .changed {
            if let attach = attach {
                attach.anchorPoint = location
            }
        } else if sender.state == .ended {
            if let attach = attach {
                animator.removeBehavior(attach)
                itemBehavior.addLinearVelocity(sender.velocity(in: self), for: objectView)
            }
        }
    }

    // MARK: - Accelerometer calculations

    func getAccelerometerData() {
        motionManager.startAccelerometerUpdates()
        motionManager.startDeviceMotionUpdates(to: motionQueue, withHandler: { motion, error in
            if error != nil {
                NSLog(String(describing: error))
            }

            guard let motion = motion else {
                print("Motion is not available")
                return
            }

            let grav: CMAcceleration = motion.gravity
            var vector = CGVector(dx: CGFloat(grav.x), dy: CGFloat(grav.y))

            DispatchQueue.main.async {
                // Correct for orientation
                let orientation = UIApplication.shared.statusBarOrientation

                if orientation == .portrait {
                    vector.dy *= -1
                } else if orientation == .landscapeLeft {
                    vector.dx = CGFloat(grav.y)
                    vector.dy = CGFloat(grav.x)
                } else if orientation == .landscapeRight {
                    vector.dx = CGFloat(-grav.y)
                    vector.dy = CGFloat(-grav.x)
                }

                self.gravity.gravityDirection = vector
            }
        })
    }
}
