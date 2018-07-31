//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class RadioButtonImageView: AnimatedImageView {
    private let selectedImageName = "radiobutton-select"
    private let selectedImageCount = 13
    
    private let unselectedImageName = "radiobutton-unselected"
    private let unselectedImageCount = 10

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
