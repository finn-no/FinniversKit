import UIKit

class AnimatedCheckboxImageView: AnimatedImageView {
    var selectedImage: UIImage?
    var selectedImages: [UIImage]?
    var unselectedImage: UIImage?
    var unselectedImages: [UIImage]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        animationRepeatCount = 1
        setImages()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setImages() {
        guard let selectedImages = UIImage.animatedImageNamed("checkbox-selected-", duration: 20 / AnimatedImageView.framesPerSecond)?.images,
            let unselectedImages = UIImage.animatedImageNamed("checkbox-unselected-", duration: 14 / AnimatedImageView.framesPerSecond)?.images else {
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
        
        selectedDuration = Double(selectedImages.count) / AnimatedCheckboxImageView.framesPerSecond
        unselectedDuration = Double(unselectedImages.count) / AnimatedCheckboxImageView.framesPerSecond
    }
    
    func animateCheckbox(selected: Bool) {
        if isAnimating {
            cancelAnimation()
            isHighlighted = selected
            return
        }
        
        isHighlighted = selected
        animationDuration = selected ? selectedDuration : unselectedDuration
        startAnimating()
    }
}
