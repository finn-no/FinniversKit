//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class CheckboxImageView: AnimatedImageView {
    private let selectedImageName = "checkbox-selected"
    private let selectedImageCount = 20
    
    private let unselectedImageName = "checkbox-unselected"
    private let unselectedImageCount = 14

    public init() {
        super.init(frame: .zero)
        loadImages()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func loadImages() {
        highlightedAnimationImages = [UIImage]()
        animationImages = [UIImage]()

        for i in 0 ..< selectedImageCount {
            if let image = UIImage(named: "\(selectedImageName)-\(i)", in: FinniversKit.bundle, compatibleWith: nil) {
                highlightedAnimationImages?.append(image)
            }
        }

        for i in 0 ..< unselectedImageCount {
            if let image = UIImage(named: "\(unselectedImageName)-\(i)", in: FinniversKit.bundle, compatibleWith: nil) {
                animationImages?.append(image)
            }
        }

        image = animationImages?.last
        highlightedImage = highlightedAnimationImages?.last

        if let selected = highlightedAnimationImages {
            selectedDuration = Double(selected.count) / AnimatedImageView.framesPerSecond
        }
        if let unselected = animationImages {
            unselectedDuration = Double(unselected.count) / AnimatedImageView.framesPerSecond
        }
    }
}
