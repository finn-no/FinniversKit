//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class SelectionIndicatorView: UIView {
    let imageView: AnimatedImageView = {
        let view = AnimatedImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        view.animationRepeatCount = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    public var isSelected: Bool = false {
        didSet {
            animateImage(selected: isSelected)
        }
    }

    public var unselectedImage: UIImage? {
        didSet {
            imageView.image = unselectedImage
        }
    }

    public var unselectedAnimationImages: [UIImage]? {
        didSet {
            imageView.animationImages = unselectedAnimationImages
            if let unselected = unselectedAnimationImages {
                imageView.unselectedDuration = Double(unselected.count) / AnimatedImageView.framesPerSecond
            }
        }
    }

    public var selectedImage: UIImage? {
        didSet {
            imageView.highlightedImage = selectedImage
        }
    }

    public var selectedAnimationImages: [UIImage]? {
        didSet {
            imageView.highlightedAnimationImages = selectedAnimationImages
            if let selected = selectedAnimationImages {
                imageView.selectedDuration = Double(selected.count) / AnimatedImageView.framesPerSecond
            }
        }
    }

    public var type: SelectionBoxType = .check

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyle()
        setupSubviews()
    }

    init(type: SelectionBoxType) {
        self.type = type
        super.init(frame: .zero)
        setupStyle()
        setupSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        translatesAutoresizingMaskIntoConstraints = false
        addSubview(imageView)
        imageView.fillInSuperview()
    }

    private func setupStyle() {
        let framesPerSecond = 60.0

        let radiobuttonSelected = UIImage.animatedImageNamed(type.selected, duration: 13 / framesPerSecond)
        let radiobuttonUnselected = UIImage.animatedImageNamed(type.unselected, duration: 10 / framesPerSecond)

        selectedImage = radiobuttonSelected?.images?.last
        selectedAnimationImages = radiobuttonSelected?.images
        unselectedImage = radiobuttonUnselected?.images?.last
        unselectedAnimationImages = radiobuttonUnselected?.images
    }

    private func animateImage(selected: Bool) {
        if imageView.isAnimating {
            imageView.cancelAnimation()
            imageView.isHighlighted = selected
            return
        }

        imageView.isHighlighted = selected
        imageView.animationDuration = selected ? imageView.selectedDuration : imageView.unselectedDuration
        imageView.startAnimating()
    }
}

public enum SelectionBoxType {
    case radio
    case check

    var selected: String {
        switch self {
        case .radio:
            return "radiobutton-select-"
        case .check:
            return "checkbox-selected-"
        }
    }

    var unselected: String {
        switch self {
        case .radio:
            return "radiobutton-unselected-"
        case .check:
            return "checkbox-unselected-"
        }
    }
}
