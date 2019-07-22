//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

/* Selection box for selecting a single item */

public protocol RadioButtonDelegate: AnyObject {
    func radioButton(_ radioButton: RadioButton, didSelectItem item: RadioButtonItem)
    func radioButton(_ radioButton: RadioButton, didUnselectItem item: RadioButtonItem)
}

public class RadioButton: Selectionbox {
    // MARK: Public properties

    public var selectedItem: RadioButtonItem?
    public weak var delegate: RadioButtonDelegate?

    // MARK: Private properties

    fileprivate override var animatedImageView: AnimatedRadioButtonView {
        return AnimatedRadioButtonView(frame: .zero)
    }

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

public protocol CheckboxDelegate: AnyObject {
    func checkbox(_ checkbox: Checkbox, didSelectItem item: CheckboxItem)
    func checkbox(_ checkbox: Checkbox, didUnselectItem item: CheckboxItem)
}

public class Checkbox: Selectionbox {
    // MARK: Public properties

    public var selectedItems: Set<CheckboxItem> = []
    public weak var delegate: CheckboxDelegate?

    // MARK: Private properties

    fileprivate override var animatedImageView: AnimatedCheckboxView {
        return AnimatedCheckboxView(frame: .zero)
    }

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

    fileprivate var animatedImageView: AnimatedSelectionView {
        fatalError("Override this in your subclass to return an appropriate animated image")
    }

    private var highlightedItem: SelectionboxItem?

    private let titleLabel: UILabel = {
        let label = Label(style: .title3)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let stack: UIStackView = {
        let stack = UIStackView(withAutoLayout: true)
        stack.axis = .vertical
        stack.distribution = .fillEqually
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

            stack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumSpacing),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing)
            ])
    }

    private func setupBoxes(with strings: [String]) {
        for (index, string) in strings.enumerated() {
            let item = SelectionboxItem(index: index, animatedImageView: animatedImageView)
            item.titleLabel.text = string
            stack.addArrangedSubview(item)
        }
    }

    private func setFields() {
        for (index, string) in fields.enumerated() {
            let item = SelectionboxItem(index: index, animatedImageView: animatedImageView)
            item.titleLabel.text = string
            stack.addArrangedSubview(item)
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
