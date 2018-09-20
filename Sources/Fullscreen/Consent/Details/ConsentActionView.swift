//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit

public class ConsentActionView: UIView {

    public var text: String? {
        get { return textLabel.attributedText?.string }
        set { textLabel.attributedText = newValue?.withLineSpacing(4) }
    }

    public var buttonTitle: String? {
        didSet {
            button?.setTitle(buttonTitle, for: .normal)
        }
    }

    public var action: (() -> Void)?

    private lazy var textLabel: Label = {
        let label = Label(style: .body)
        label.textColor = .stone
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var button: Button?
    public var buttonStyle: Button.Style? {
        get { return button?.style }
        set { button = createButton(with: newValue) }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ConsentActionView {

    func createButton(with style: Button.Style?) -> Button? {
        if let button = button {
            button.removeFromSuperview()
        }

        guard let style = style else { return nil }
        let newButton = Button(style: style)
        newButton.setTitle(buttonTitle, for: .normal)
        newButton.addTarget(self, action: #selector(handleButtonPressed), for: .touchUpInside)
        newButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(newButton)

        let constraints = [
            newButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            newButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            newButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: .largeSpacing),
        ]
        NSLayoutConstraint.activate(constraints)

        return button
    }

    func setupSubviews() {
        addSubview(textLabel)
        let constraints = [
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            textLabel.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    @objc func handleButtonPressed() {
        action?()
    }

}
