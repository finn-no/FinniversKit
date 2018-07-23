//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

/* UIImageView which will play the current animation
 sequence in reverse when it is cancelled. The
 initial frame of the reverse animation will be the
 current frame of the cancelled animation */

class AnimatedImageView: UIImageView {
    private var startTime: TimeInterval?
    private var reverseImageView: UIImageView? // Used for reversing an animation

    var selectedDuration = 0.0
    var unselectedDuration = 0.0

    override func startAnimating() {
        if let reverse = reverseImageView {
            reverse.removeFromSuperview()
            reverseImageView = nil
        }

        super.startAnimating()
        startTime = CACurrentMediaTime()
    }

    func cancelAnimation() {
        super.stopAnimating()
        // Get current animation frame
        guard let startTime = startTime else { return }
        let elapsedTime = CACurrentMediaTime() - startTime
        let currentAnimationFrame = Int(60.0 * elapsedTime)

        guard let images = isHighlighted ? highlightedAnimationImages : animationImages else { return }
        guard currentAnimationFrame < images.count else { return }

        let animationSequence = images[..<currentAnimationFrame].reversed()

        let reverse = UIImageView(frame: bounds)
        addSubview(reverse)

        reverse.image = animationSequence.last
        reverse.animationRepeatCount = 1
        reverse.animationImages = Array(animationSequence)
        reverse.animationDuration = Double(animationSequence.count) / 60.0
        reverse.startAnimating()
        reverseImageView = reverse
    }
}
