//
//  Copyright © 2018 FINN AS. All rights reserved.
//
import UIKit


public class ConsentDetailView: UIView {

    public var model: ConsentDetailViewModel? {
        didSet { set(model: model) }
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

    lazy var switchLabel: Label = {
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
        addSubview(switchLabel)
        addSubview(theSwitch)
        addSubview(button)

        let constraints = [
            switchLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            switchLabel.topAnchor.constraint(equalTo: topAnchor, constant: .largeSpacing),

            theSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            theSwitch.centerYAnchor.constraint(equalTo: switchLabel.centerYAnchor),

            textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            textView.topAnchor.constraint(equalTo: switchLabel.bottomAnchor, constant: .largeSpacing),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            button.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: .mediumLargeSpacing + .smallSpacing)
        ]
        NSLayoutConstraint.activate(constraints)
    }

    func set(model: ConsentDetailViewModel?) {
        guard let model = model else { return }
        textView.text = model.definition
        switchLabel.text = model.heading
    }

}
