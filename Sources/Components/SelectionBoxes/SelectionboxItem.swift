//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

// Naming for convenience
public typealias RadioButtonItem = SelectionboxItem
public typealias CheckboxItem = SelectionboxItem

public class SelectionboxItem: UIView {
    // MARK: Internal properties

    let imageView: AnimatedSelectionView

    let titleLabel: UILabel = {
        let label = Label(style: .body)
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
            imageView.animateSelection(selected: isSelected)
        }
    }

    // MARK: Implementation

    public init(index: Int, animatedImageView: AnimatedSelectionView) {
        self.index = index
        self.imageView = animatedImageView
        super.init(frame: .zero)
        setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SelectionboxItem {
    private func setupSubviews() {
        addSubview(imageView)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 40),

            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),

            titleLabel.heightAnchor.constraint(greaterThanOrEqualTo: imageView.heightAnchor, multiplier: 1.0),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: .mediumSpacing),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -.mediumLargeSpacing)
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
