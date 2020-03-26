//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class AnimatedRadioButtonView: AnimatedSelectionView {
    var selectedImage: UIImage?
    var selectedImages: [UIImage]?
    var unselectedImage: UIImage?
    var unselectedImages: [UIImage]?

    public required init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        setImages()
    }

    public required init?(coder aDecoder: NSCoder) {
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
        var selectedImages = [UIImage]()
        for index in 0 ..< 13 {
            if let image = UIImage(named: "radiobutton-select-\(index)", in: FinniversKit.bundle, compatibleWith: nil) {
                selectedImages.append(image)
            }
        }

        var unselectedImages = [UIImage]()
        for index in 0 ..< 11 {
            if let image = UIImage(named: "radiobutton-unselected-\(index)", in: FinniversKit.bundle, compatibleWith: nil) {
                unselectedImages.append(image)
            }
        }

        self.selectedImage = selectedImages.last
        self.selectedImages = selectedImages
        self.unselectedImage = unselectedImages.last
        self.unselectedImages = unselectedImages

        image = self.unselectedImage
        animationImages = self.unselectedImages
        highlightedImage = self.selectedImage
        highlightedAnimationImages = self.selectedImages

        selectedDuration = Double(selectedImages.count) / AnimatedSelectionView.framesPerSecond
        unselectedDuration = Double(unselectedImages.count) / AnimatedSelectionView.framesPerSecond
    }
}
