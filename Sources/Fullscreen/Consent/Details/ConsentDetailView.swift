//
//  Copyright © 2018 FINN AS. All rights reserved.
//
import UIKit


public class ConsentDetailView: UIView {

    public var text: String? {
        get { return textView.attributedText?.string }
        set { textView.attributedText = newValue?.withLineSpacing(4) }
    }

    public var heading: String? {
        get { return headingView.text }
        set { headingView.text = newValue }
    }

    public var buttonTitle: String? {
        didSet { button.setTitle(buttonTitle, for: .normal) }
    }

    lazy var textView: Label = {
        let label = Label(style: .body)
        label.textColor = .stone
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var headingView: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var theSwitch: UISwitch = {
        let view = UISwitch(frame: .zero)
        view.onTintColor = .pea
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var button: Button = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

private extension ConsentDetailView {
    func setupSubviews() {
        addSubview(textView)
        addSubview(headingView)
        addSubview(theSwitch)
        addSubview(button)

        let constraints = [
            headingView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            headingView.topAnchor.constraint(equalTo: topAnchor, constant: .largeSpacing),

            theSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            theSwitch.centerYAnchor.constraint(equalTo: headingView.centerYAnchor),

            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            textView.topAnchor.constraint(equalTo: headingView.bottomAnchor, constant: .largeSpacing),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            button.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: .mediumLargeSpacing + .smallSpacing)
        ]
        NSLayoutConstraint.activate(constraints)
    }

}
