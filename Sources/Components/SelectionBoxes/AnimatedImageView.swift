//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

/** UIImageView which will play the current animation
 sequence in reverse when it is cancelled. The
 initial frame of the reverse animation will be the
 current frame of the cancelled animation **/

class AnimatedImageView: UIImageView {
    
    // MARK: Static properties
    
    static var framesPerSecond = 60.0

    // MARK: Internal properties

    var selectedDuration = 0.0
    var unselectedDuration = 0.0

    // MARK: Private properties

    private var startTime: TimeInterval?
    private var reverseImageView: UIImageView // Used for reversing an animation

    // MARK: Implementation

    override init(frame: CGRect) {
        reverseImageView = UIImageView(frame: .zero)
        super.init(frame: frame)
        
        reverseImageView.isHidden = true
        addSubview(reverseImageView)
    }

    override func startAnimating() {
        reverseImageView.stopAnimating()
        reverseImageView.isHidden = true

        super.startAnimating()
        startTime = CACurrentMediaTime()
    }

    func cancelAnimation() {
        super.stopAnimating()

        // Get current animation frame
        guard let startTime = startTime else { return }
        let elapsedTime = CACurrentMediaTime() - startTime
        let currentAnimationFrame = Int(AnimatedImageView.framesPerSecond * elapsedTime)

        guard let images = isHighlighted ? highlightedAnimationImages : animationImages else { return }
        guard currentAnimationFrame < images.count else { return }

        let animationSequence = images[..<currentAnimationFrame].reversed()

        reverseImageView.isHidden = false
        reverseImageView.frame = bounds
        reverseImageView.image = animationSequence.last
        reverseImageView.animationRepeatCount = 1
        reverseImageView.animationImages = Array(animationSequence)
        reverseImageView.animationDuration = Double(animationSequence.count) / AnimatedImageView.framesPerSecond
        reverseImageView.startAnimating()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
