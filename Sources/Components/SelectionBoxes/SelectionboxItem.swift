//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

// Naming for convenience
public typealias RadioButtonItem = SelectionboxItem
public typealias CheckboxItem = SelectionboxItem

public class SelectionboxItem: UIView {
    // MARK: Internal properties

    let imageView: AnimatedImageView = {
        let view = AnimatedImageView(frame: .zero)
        view.contentMode = .scaleAspectFit
        view.animationRepeatCount = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let titleLabel: UILabel = {
        let label = Label(style: .body)
        label.textColor = .licorice
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: Public properties

    public var index: Int

    public var text: String? {
        return titleLabel.text
    }

    public var isSelected: Bool = false {
        didSet {
            animateImage(selected: isSelected)
        }
    }

    // MARK: Implementation

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
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            // Make sure item is bigger than imageView height if title text is small
            heightAnchor.constraint(greaterThanOrEqualTo: titleLabel.heightAnchor, multiplier: 1.0, constant: .mediumLargeSpacing),
            titleLabel.heightAnchor.constraint(greaterThanOrEqualTo: imageView.heightAnchor, multiplier: 1.0),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: .mediumLargeSpacing),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }
}

extension SelectionboxItem {
    @objc dynamic var textColor: UIColor {
        get { return titleLabel.textColor }
        set { titleLabel.textColor = newValue }
    }

    @objc dynamic var font: UIFont {
        get { return titleLabel.font }
        set { titleLabel.font = newValue }
    }
}
