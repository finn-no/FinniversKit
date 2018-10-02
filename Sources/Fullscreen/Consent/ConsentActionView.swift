//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit

public class ConsentActionView: UIView {

    // MARK: - Private properties

    private lazy var textLabel: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .stone
        label.numberOfLines = 0
        return label
    }()

    private var button: Button?

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: .zero)
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.alwaysBounceVertical = true
        return scroll
    }()

    // MARK: - Public properties

    public var buttonStyle: Button.Style? {
        get { return button?.style }
        set { button = createButton(with: newValue) }
    }

    public var text: String? {
        get { return textLabel.attributedText?.string }
        set { textLabel.attributedText = newValue?.attributedStringWithLineSpacing(4) }
    }

    public var buttonTitle: String? {
        didSet { button?.setTitle(buttonTitle, for: .normal) }
    }

    public var action: (() -> Void)?

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private functions

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
        scrollView.addSubview(newButton)

        let constraints = [
            newButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            newButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            newButton.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: .largeSpacing),
            scrollView.bottomAnchor.constraint(equalTo: newButton.bottomAnchor, constant: .mediumLargeSpacing)
        ]
        NSLayoutConstraint.activate(constraints)

        return button
    }

    func setupSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(textLabel)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: heightAnchor),

            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            textLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: .mediumLargeSpacing),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            scrollView.bottomAnchor.constraint(greaterThanOrEqualTo: textLabel.bottomAnchor, constant: .mediumLargeSpacing)
        ])
    }

    @objc func handleButtonPressed() {
        action?()
    }

}
