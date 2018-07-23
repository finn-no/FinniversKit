//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class SelectionboxItem: UIView {
    let imageView: AnimatedImageView = {
        let view = AnimatedImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        view.animationRepeatCount = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let label: UILabel = {
        let label = Label(style: .body(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    public var index: Int

    public var text: String? {
        return label.text
    }

    public var isSelected: Bool = false {
        didSet {
            animateImage(selected: isSelected)
        }
    }

    public init(index: Int) {
        self.index = index
        super.init(frame: .zero)
        setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SelectionboxItem {
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

    private func setupSubviews() {
        addSubview(imageView)
        addSubview(label)
        NSLayoutConstraint.activate([
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}

extension SelectionboxItem {
    @objc dynamic var textColor: UIColor {
        get { return label.textColor }
        set { label.textColor = newValue }
    }

    @objc dynamic var font: UIFont {
        get { return label.font }
        set { label.font = newValue }
    }
}
