//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

/* Selection box for selecting a single item */

public protocol RadioButtonDelegate: class {
    func radioButton(_ radioButton: RadioButton, didSelectItem item: RadioButtonItem)
    func radioButton(_ radioButton: RadioButton, didUnselectItem item: RadioButtonItem)
}

public class RadioButton: Selectionbox {

    // MARK: Public properties

    public var selectedItem: RadioButtonItem?
    public weak var delegate: RadioButtonDelegate?

    fileprivate override func handleSelecting(_ item: RadioButtonItem) {
        selectedItem?.isSelected = false
        if let selectedItem = selectedItem {
            delegate?.radioButton(self, didUnselectItem: selectedItem)
        }

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
    func checkbox(_ checkbox: Checkbox, didSelectItem item: CheckboxItem)
    func checkbox(_ checkbox: Checkbox, didUnselectItem item: CheckboxItem)
}

public class Checkbox: Selectionbox {

    // MARK: Public properties

    public var selectedItems: Set<CheckboxItem> = []
    public weak var delegate: CheckboxDelegate?

    fileprivate override func handleSelecting(_ item: CheckboxItem) {
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

    public var fields = [String]() {
        didSet {
            setFields()
        }
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

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    public init(strings: [String]) {
        super.init(frame: .zero)
        setupBoxes(with: strings)
        setupSubviews()
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

    private func setupSubviews() {
        addSubview(titleLabel)
        addSubview(stack)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),

            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            stack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumSpacing),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: .mediumLargeSpacing),
        ])
    }

    private func setupBoxes(with strings: [String]) {
        for (i, string) in strings.enumerated() {
            let item = SelectionboxItem(index: i)
            item.titleLabel.text = string
            stack.addArrangedSubview(item)
        }
    }

    private func setFields() {
        for (i, string) in fields.enumerated() {
            let item = SelectionboxItem(index: i)
            item.titleLabel.text = string
            stack.addArrangedSubview(item)
        }
        setImages()
    }

    private func setImages() {
        guard let items = stack.arrangedSubviews as? [SelectionboxItem] else { return }
        for item in items {
            item.imageView.image = unselectedImage
            item.imageView.animationImages = unselectedAnimationImages
            item.imageView.highlightedImage = selectedImage
            item.imageView.highlightedAnimationImages = selectedAnimationImages

            if let unselected = unselectedAnimationImages {
                item.imageView.unselectedDuration = Double(unselected.count) / AnimatedImageView.framesPerSecond
            }
            if let selected = selectedAnimationImages {
                item.imageView.selectedDuration = Double(selected.count) / AnimatedImageView.framesPerSecond
            }
        }
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
