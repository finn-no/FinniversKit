//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

extension SpringAnimator {
    enum State {
        case animating, paused, cancelled, stopped
    }
}

class SpringAnimator: NSObject {

    // Spring properties
    let damping: CGFloat
    let stiffness: CGFloat

    // View properties
    private var velocity = 0.0 as CGFloat
    private var position = 0.0 as CGFloat
    var initialVelocity: CGFloat = 0 {
        didSet { velocity = -initialVelocity }
    }

    // Animation properties
    var state: State = .stopped

    var targetPosition = 0 as CGFloat
    var constraint: NSLayoutConstraint?

    var completion: ((Bool) -> Void)?

    private let scale = 1 / UIScreen.main.scale
    private var displayLink: CADisplayLink?

    init(dampingRatio: CGFloat, frequencyResponse: CGFloat) {
        self.stiffness = pow(2 * .pi / frequencyResponse, 2)
        self.damping = 2 * dampingRatio * sqrt(stiffness)
    }

    func startAnimation() {
        if state == .paused { continueAnimation() }

        guard let constraint = constraint else { return }
        position = targetPosition - constraint.constant

        guard position != 0, displayLink == nil else { return }
        displayLink = CADisplayLink(target: self, selector: #selector(step(displayLink:)))
        displayLink?.add(to: .current, forMode: .default)
        state = .animating
    }

    func continueAnimation() {
        guard state == .paused, let constraint = constraint else { return }
        position = targetPosition - constraint.constant
        state = .animating
        displayLink?.isPaused = false
    }

    func pauseAnimation() {
        guard state == .animating else { return }
        state = .paused
        displayLink?.isPaused = true
    }

    func stopAnimation() {
        switch state {
        case .animating, .paused: stopAnimation(didComplete: false)
        default: return
        }
    }
}

private extension SpringAnimator {

    @objc func step(displayLink: CADisplayLink) {
        let acceleration = -velocity * damping - position * stiffness
        velocity += acceleration * CGFloat(displayLink.duration)
        position += velocity * CGFloat(displayLink.duration)
        constraint?.constant = targetPosition - position

        if abs(position) < scale, abs(velocity) < scale {
            stopAnimation(didComplete: true)
        }
    }

    func stopAnimation(didComplete: Bool) {
        if didComplete { constraint?.constant = targetPosition }
        displayLink?.invalidate()
        displayLink = nil
        completion?(didComplete)
        completion = nil

        switch didComplete {
        case true: state = .stopped
        case false: state = .cancelled
        }
    }
}
