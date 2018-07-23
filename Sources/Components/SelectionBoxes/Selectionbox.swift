//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

/* Selection box for selecting a singel item */

public class RadioButton: Selectionbox {
    public var selectedItem: SelectionboxItem?

    fileprivate override func handleSelecting(_ item: SelectionboxItem) {
        selectedItem?.isSelected = false

        if item === selectedItem {
            selectedItem = nil
            return
        }

        item.isSelected = true
        selectedItem = item
        delegate?.selectionbox(self, didSelectItem: item)
    }
}

/* Selection box for selecting multiple items */

public class Checkbox: Selectionbox {
    public var selectedItems: Set<SelectionboxItem> = []

    fileprivate override func handleSelecting(_ item: SelectionboxItem) {
        item.isSelected = !item.isSelected
        if item.isSelected {
            let result = selectedItems.insert(item)
            if result.inserted { delegate?.selectionbox(self, didSelectItem: result.memberAfterInsert) }
        } else {
            guard let removedItem = selectedItems.remove(item) else { return }
            delegate?.selectionbox(self, didUnselectItem: removedItem)
        }
    }
}

/* Base class for selections */

public protocol SelectionboxDelegate: class {
    func selectionbox(_ selectionbox: Selectionbox, didSelectItem item: SelectionboxItem)
    func selectionbox(_ selectionbox: Selectionbox, didUnselectItem item: SelectionboxItem)
}

public class Selectionbox: UIView {
    public var unselectedImage: UIImage? {
        didSet {
            for item in stack.arrangedSubviews as! [SelectionboxItem] {
                item.imageView.image = unselectedImage
            }
        }
    }

    public var unselectedAnimationImages: [UIImage]? {
        didSet {
            for item in stack.arrangedSubviews as! [SelectionboxItem] {
                item.imageView.animationImages = unselectedAnimationImages
                if let unselected = unselectedAnimationImages {
                    item.imageView.unselectedDuration = Double(unselected.count) / 60.0
                }
            }
        }
    }

    public var selectedImage: UIImage? {
        didSet {
            for item in stack.arrangedSubviews as! [SelectionboxItem] {
                item.imageView.highlightedImage = selectedImage
            }
        }
    }

    public var selectedAnimationImages: [UIImage]? {
        didSet {
            for item in stack.arrangedSubviews as! [SelectionboxItem] {
                item.imageView.highlightedAnimationImages = selectedAnimationImages
                if let selected = selectedAnimationImages {
                    item.imageView.selectedDuration = Double(selected.count) / 60.0
                }
            }
        }
    }

    public var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }

    public weak var delegate: SelectionboxDelegate?

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
    private func setupBoxes(with strings: [String]) {
        for (i, string) in strings.enumerated() {
            let item = SelectionboxItem(index: i)
            item.label.text = string
            stack.addArrangedSubview(item)
        }

        addSubview(titleLabel)
        addSubview(stack)

        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),

            stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            stack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
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
