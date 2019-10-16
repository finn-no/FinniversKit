//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit

public protocol ConsentActionViewDelegate: AnyObject {
    func consentActionViewDidPressButton(_ consentActionView: ConsentActionView)
}

public class ConsentActionView: UIView {
    // MARK: - Private properties

    private lazy var textLabel: Label = {
        let label = Label(style: .body)
        label.textColor = .textSecondary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var button: Button = {
        let button = Button(style: .callToAction)
        button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var buttonBackgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .bgPrimary
        view.layer.shadowOffset = .zero
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var contentView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.delegate = self
        scrollView.alwaysBounceVertical = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    // MARK: - Public properties

    public var shadowAnimationDuration = 0.12
    public var lineSpacing: CGFloat = 4
    public weak var delegate: ConsentActionViewDelegate?
    public var model: ConsentActionViewModel? {
        didSet { set(model: model) }
    }

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        guard textLabel.intrinsicContentSize.height + .largeSpacing >= buttonBackgroundView.frame.minY else { return }
        buttonBackgroundView.layer.shadowOpacity = 0.2
    }
}

// MARK: - ScrollView Delegate

extension ConsentActionView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if -scrollView.contentOffset.y + textLabel.intrinsicContentSize.height + .largeSpacing >= buttonBackgroundView.frame.minY {
            animateShadow(fromValue: 0, toValue: 0.2, duration: shadowAnimationDuration)
        } else {
            animateShadow(fromValue: 0.2, toValue: 0, duration: shadowAnimationDuration)
        }
    }
}

// MARK: - Private methods

private extension ConsentActionView {
    func animateShadow(fromValue from: Float, toValue to: Float, duration: Double) {
        guard buttonBackgroundView.layer.shadowOpacity != to else { return }
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        buttonBackgroundView.layer.add(animation, forKey: nil)
        buttonBackgroundView.layer.shadowOpacity = to
    }

    @objc func buttonPressed(sender: UIButton) {
        delegate?.consentActionViewDidPressButton(self)
    }

    func set(model: ConsentActionViewModel?) {
        guard let model = model else { return }
        textLabel.attributedText = model.text.attributedStringWithLineSpacing(lineSpacing)
        button.style = model.buttonStyle
        button.setTitle(model.buttonTitle, for: .normal)
    }

    func newButton(with style: Button.Style) -> Button {
        let button = Button(style: style)
        button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    func setup() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(textLabel)
        addSubview(buttonBackgroundView)
        addSubview(button)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonBackgroundView.topAnchor),

            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            textLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .largeSpacing),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            textLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumLargeSpacing),

            buttonBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            buttonBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonBackgroundView.topAnchor.constraint(equalTo: button.topAnchor, constant: -.mediumLargeSpacing),

            button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing)
        ])
    }
}
