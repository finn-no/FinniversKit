//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class AnimatedHeartView: AnimatedSelectionView {
    var selectedImage: UIImage?
    var unselectedImage: UIImage?

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
            widthAnchor.constraint(equalToConstant: 28),
            heightAnchor.constraint(equalToConstant: 28)
            ])
    }

    private func setImages() {
        self.selectedImage = .brandFavouriteAddedImg
        self.unselectedImage = .brandFavouriteAddImg

        image = self.unselectedImage
        highlightedImage = self.selectedImage

        selectedDuration = Double(1) / AnimatedSelectionView.framesPerSecond
        unselectedDuration = Double(1) / AnimatedSelectionView.framesPerSecond
    }
}
