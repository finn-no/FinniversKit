//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

extension SpringAnimator {
    enum State {
        case inactive, active, stopped
    }
}

class SpringAnimator: NSObject {

    var fromPosition: CGPoint = .zero {
        didSet {
            position = toPosition - fromPosition
        }
    }

    var toPosition: CGPoint = .zero {
        didSet {
            position = toPosition - fromPosition
        }
    }

    var initialVelocity: CGPoint = .zero {
        didSet {
            velocity = initialVelocity
        }
    }

    var state: State = .stopped
    var isRunning: Bool = false
    var completion: ((Bool) -> Void)?
    // MARK: - Spring physics
    private let damping: CGFloat
    private let stiffness: CGFloat
    private var velocity: CGPoint = .zero
    private var position: CGPoint = .zero
    // MARK: - Animation properties
    private var animations: [(CGPoint) -> Void] = []
    private lazy var displayLink = CADisplayLink(target: self, selector: #selector(step(displayLink:)))
    private let scale = 1 / UIScreen.main.scale

    // MARK: - Setup
    init(dampingRatio: CGFloat, frequencyResponse: CGFloat) {
        self.stiffness = pow(2 * .pi / frequencyResponse, 2)
        self.damping = 2 * dampingRatio * sqrt(stiffness)
    }

    // MARK: - ViewAnimating
    func addAnimation(_ animation: @escaping (CGPoint) -> Void) {
        animations.append(animation)
    }

    func startAnimation() {
        guard !isRunning else { return }
        switch state {
        case .stopped:
            displayLink.add(to: .current, forMode: .common)
        case .inactive:
            displayLink.isPaused = false
        default:
            break
        }
        isRunning = true
        state = .active
    }

    func pauseAnimation() {
        guard isRunning else { return }
        displayLink.isPaused = true
        isRunning = false
        state = .inactive
    }

    func stopAnimation(_ withoutFinishing: Bool) {
        guard isRunning else { return }
        displayLink.remove(from: .current, forMode: .common)
        isRunning = false
        state = .stopped
        completion?(!withoutFinishing)
    }
}

private extension SpringAnimator {
    @objc func step(displayLink: CADisplayLink) {
        // Calculate new potision
        let acceleration = -velocity * damping - position * stiffness
        velocity += acceleration * CGFloat(displayLink.duration)
        position += velocity * CGFloat(displayLink.duration)
        // If it moves less than a pixel, animation is done
        if position < scale, velocity < scale {
            stopAnimation(false)
            position = .zero
        }
        // Call to animation blocks
        animations.forEach { animation in
            animation(toPosition - position)
        }
    }
}
