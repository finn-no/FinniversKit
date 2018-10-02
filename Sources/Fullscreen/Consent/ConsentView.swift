//
//  Copyright © 2018 FINN AS. All rights reserved.
//
import UIKit

public protocol ConsentViewDelegate: class {
    func consentView(_ consentView: ConsentView, didToggleSwitch position: Bool)
    func consentView(_ consentView: ConsentView, didPressButtonAt indexPath: IndexPath)
}

public class ConsentView: UIView {

    // MARK: - Private properties

    private var titleLabel: Label?
    private var _switch: UISwitch?

    private lazy var textLabel: Label = {
        let label = Label(style: .body)
        label.textColor = .stone
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var button: Button = buttonWith(style: .flat)

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: .zero)
        scroll.alwaysBounceVertical = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    // MARK: - Public properties

    public var model: ConsentViewModel? {
        didSet { set(model: model) }
    }

    public var state: Bool = false {
        didSet { _switch?.setOn(state, animated: false) }
    }

    public weak var delegate: ConsentViewDelegate?

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupScrollView()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Private functions

private extension ConsentView {
    func setupScrollView() {
        addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: heightAnchor)
        ])
    }

    func set(model: ConsentViewModel?) {
        guard let model = model else { return }

        var aboveAnchor = topAnchor
        if let title = model.title {
            let label = titleLabel(with: title)
            aboveAnchor = label.bottomAnchor

            let s = switchWithTarget()

            scrollView.addSubview(label)
            scrollView.addSubview(s)

            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: .largeSpacing),
                label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .mediumLargeSpacing),
                label.trailingAnchor.constraint(lessThanOrEqualTo: s.leadingAnchor, constant: -.mediumSpacing),

                s.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
                s.centerYAnchor.constraint(equalTo: label.centerYAnchor)
            ])
        }

        textLabel.attributedText = model.text.attributedStringWithLineSpacing(4)
        button.setTitle(model.buttonTitle, for: .normal)

        scrollView.addSubview(textLabel)
        scrollView.addSubview(button)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: aboveAnchor, constant: .largeSpacing),
            textLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .mediumLargeSpacing),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            button.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            button.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: .mediumLargeSpacing + .smallSpacing),

            scrollView.bottomAnchor.constraint(equalTo: button.bottomAnchor, constant: .mediumLargeSpacing)
        ])

        guard model.buttonStyle != .flat else { return }

        button.removeFromSuperview()

        let b = buttonWith(style: model.buttonStyle)
        b.setTitle(model.buttonTitle, for: .normal)

        addSubview(b)
        NSLayoutConstraint.activate([
            b.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            b.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            b.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing),
        ])
    }

    func titleLabel(with text: String) -> Label {
        let label = Label(style: .body)
        label.text = text
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func switchWithTarget() -> UISwitch {
        let view = UISwitch(frame: .zero)
        view.onTintColor = .pea
        view.addTarget(self, action: #selector(switchDidToogle(sender:)), for: .valueChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    func buttonWith(style: Button.Style) -> Button {
        let button = Button(style: style)
        button.addTarget(self, action: #selector(readMoreButtonPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    @objc func switchDidToogle(sender: UISwitch) {
        delegate?.consentView(self, didToggleSwitch: sender.isOn)
    }
    @objc func readMoreButtonPressed(sender: UIButton) {
        guard let indexPath = model?.indexPath else { return }
        delegate?.consentView(self, didPressButtonAt: indexPath)
    }

}
