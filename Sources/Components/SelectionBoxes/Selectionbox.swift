//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

/* Selection box for selecting a single item */

public protocol RadioButtonDelegate: class {
    func radioButton(_ radioButton: RadioButton, didSelectItem item: SelectionboxItem)
    func radioButton(_ radioButton: RadioButton, didUnselectItem item: SelectionboxItem)
}

public class RadioButton: Selectionbox {

    // MARK: Public properties

    public var selectedItem: SelectionboxItem?
    public weak var delegate: RadioButtonDelegate?

    fileprivate override func handleSelecting(_ item: SelectionboxItem) {
        selectedItem?.isSelected = false

        if item === selectedItem {
            selectedItem = nil
            return
        }

        item.isSelected = true
        selectedItem = item
        delegate?.radioButton(self, didSelectItem: item)
    }
}

/* Selection box for selecting multiple items */

public protocol CheckboxDelegate: class {
    func checkbox(_ checkbox: Checkbox, didSelectItem item: SelectionboxItem)
    func checkbox(_ checkbox: Checkbox, didUnselectItem item: SelectionboxItem)
}

public class Checkbox: Selectionbox {

    // MARK: Public properties

    public var selectedItems: Set<SelectionboxItem> = []
    public weak var delegate: CheckboxDelegate?

    fileprivate override func handleSelecting(_ item: SelectionboxItem) {
        item.isSelected = !item.isSelected
        if item.isSelected {
            let result = selectedItems.insert(item)
            if result.inserted { delegate?.checkbox(self, didSelectItem: result.memberAfterInsert) }
        } else {
            guard let removedItem = selectedItems.remove(item) else { return }
            delegate?.checkbox(self, didUnselectItem: removedItem)
        }
    }
}

/* Base class for selections */

public class Selectionbox: UIView {

    // MARK: Public properties

    public var unselectedImage: UIImage? {
        didSet {
            guard let items = stack.arrangedSubviews as? [SelectionboxItem] else { return }
            for item in items {
                item.imageView.image = unselectedImage
            }
        }
    }

    public var unselectedAnimationImages: [UIImage]? {
        didSet {
            guard let items = stack.arrangedSubviews as? [SelectionboxItem] else { return }
            for item in items {
                item.imageView.animationImages = unselectedAnimationImages
                if let unselected = unselectedAnimationImages {
                    item.imageView.unselectedDuration = Double(unselected.count) / AnimatedImageView.framesPerSecond
                }
            }
        }
    }

    public var selectedImage: UIImage? {
        didSet {
            guard let items = stack.arrangedSubviews as? [SelectionboxItem] else { return }
            for item in items {
                item.imageView.highlightedImage = selectedImage
            }
        }
    }

    public var selectedAnimationImages: [UIImage]? {
        didSet {
            guard let items = stack.arrangedSubviews as? [SelectionboxItem] else { return }
            for item in items {
                item.imageView.highlightedAnimationImages = selectedAnimationImages
                if let selected = selectedAnimationImages {
                    item.imageView.selectedDuration = Double(selected.count) / AnimatedImageView.framesPerSecond
                }
            }
        }
    }

    public var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }

    // MARK: Private properties

    private var highlightedItem: SelectionboxItem?

    private let titleLabel: UILabel = {
        let label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let stack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: Implementation

    public init(strings: [String]) {
        super.init(frame: .zero)
        setupBoxes(with: strings)
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        guard let item = hitTest(location, with: event) as? SelectionboxItem else { return }
        highlightedItem = item
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        guard let item = hitTest(location, with: event) as? SelectionboxItem else { return }
        guard item === highlightedItem else { return }
        handleSelecting(item)
    }

    fileprivate func handleSelecting(_ item: SelectionboxItem) {
        fatalError("This class should not be used directly")
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Selectionbox {
    
    // MARK: Private methods
    
    private func setupBoxes(with strings: [String]) {
        for (i, string) in strings.enumerated() {
            let item = SelectionboxItem(index: i)
            item.label.text = string
            stack.addArrangedSubview(item)
        }

        addSubview(titleLabel)
        addSubview(stack)

        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: Spacing.mediumLargeSpacing),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: Spacing.mediumSpacing),

            stack.leftAnchor.constraint(equalTo: leftAnchor, constant: Spacing.mediumLargeSpacing),
            stack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Spacing.mediumSpacing),
            stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -Spacing.mediumLargeSpacing),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
}

extension Selectionbox {
    @objc public dynamic var textColor: UIColor {
        get { return SelectionboxItem.appearance().textColor }
        set { SelectionboxItem.appearance().textColor = newValue }
    }

    @objc public dynamic var font: UIFont {
        get { return SelectionboxItem.appearance().font }
        set { SelectionboxItem.appearance().font = newValue }
    }
}
