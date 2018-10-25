//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class AnimatedRadioButtonView: AnimatedSelectionView {
    var selectedImage: UIImage?
    var selectedImages: [UIImage]?
    var unselectedImage: UIImage?
    var unselectedImages: [UIImage]?

    required init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setImages()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        animationRepeatCount = 1
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: 24),
            heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    private func setImages() {
        let framesPerSecond = AnimatedSelectionView.framesPerSecond
        guard let selectedImages = UIImage.animatedImageNamed("radiobutton-select-", duration: 13 / framesPerSecond)?.images,
            let unselectedImages = UIImage.animatedImageNamed("radiobutton-unselected-", duration: 11 / framesPerSecond)?.images else {
                fatalError("Could not instantiate animation images")
        }

        self.selectedImage = selectedImages.last
        self.selectedImages = selectedImages
        self.unselectedImage = unselectedImages.last
        self.unselectedImages = unselectedImages

        image = self.unselectedImage
        animationImages = self.unselectedImages
        highlightedImage = self.selectedImage
        highlightedAnimationImages = self.selectedImages

        selectedDuration = Double(selectedImages.count) / framesPerSecond
        unselectedDuration = Double(unselectedImages.count) / framesPerSecond
    }
}
