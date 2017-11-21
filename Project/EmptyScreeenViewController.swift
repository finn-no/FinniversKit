//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika
import TroikaDemoKit

class EmptyScreenViewController: UIViewController {

    // MARK: - Internal properties

    //    private lazy var emptyView: EmptyScreen = {
    //        let view = EmptyScreen(frame: .zero)
    //        view.translatesAutoresizingMaskIntoConstraints = false
    //        return view
    //    }()

    var square1 = UIView(frame: CGRect(x: 70, y: 100, width: 100, height: 100))
    var square2 = UIView(frame: CGRect(x: 230, y: 100, width: 90, height: 90))
    var square3 = UIView(frame: CGRect(x: 60, y: 50, width: 50, height: 50))
    var square4 = UIView(frame: CGRect(x: 260, y: 50, width: 40, height: 40))
    var animator: UIDynamicAnimator?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    private func setupView() {
        view.backgroundColor = .milk
        //        view.addSubview(emptyView)

        square1.backgroundColor = .salmon
        square2.backgroundColor = .banana
        square3.backgroundColor = .mint
        square4.backgroundColor = .toothPaste

        view.addSubview(square1)
        view.addSubview(square2)
        //        view.addSubview(square3)
        //        view.addSubview(square4)

        //        NSLayoutConstraint.activate([
        //            emptyView.topAnchor.constraint(equalTo: view.topAnchor),
        //            emptyView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        //            emptyView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        //            emptyView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        //            ])

        let allSquares = [square1, square2] // , square3, square4]

        animator = UIDynamicAnimator(referenceView: view)

        // Setup gravity
        let gravity = UIGravityBehavior(items: allSquares)
        let direction = CGVector(dx: 0, dy: 1.0)
        gravity.gravityDirection = direction

        // Setup boundries for collision
        let boundries = UICollisionBehavior(items: allSquares)
        boundries.translatesReferenceBoundsIntoBoundary = true

        // Setup elasticity for bounce
        let bounce = UIDynamicItemBehavior(items: allSquares)
        bounce.elasticity = 0.6

        // Add behaviour to animator
        animator?.addBehavior(gravity)
        animator?.addBehavior(boundries)
        animator?.addBehavior(bounce)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: view)
            if square1.frame.contains(location) {
                square1.center = location
            } else if square2.frame.contains(location) {
                square2.center = location
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: view)
            if square1.frame.contains(location) {
                square1.center = location
            } else if square2.frame.contains(location) {
                square2.center = location
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        viewDidLoad()
    }
}
