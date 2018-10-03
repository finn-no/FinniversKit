//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit

public protocol ConsentActionViewDelegate: class {
    func consentActionView(_ consentActionView: ConsentActionView, didPressButtonAt indexPath: IndexPath)
}

public class ConsentActionView: UIView {

    // MARK: - Private properties

    private lazy var textLabel: Label = {
        let label = Label(style: .body)
        label.textColor = .stone
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var button: Button = newButton(with: .callToAction)

    private var buttonBackgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .milk
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

    public var lineSpacing: CGFloat = 4
    public weak var delegate: ConsentActionViewDelegate?
    public var model: ConsentActionViewModel? {
        didSet { set(model: model) }
    }

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubViews()
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
            buttonBackgroundView.layer.shadowOpacity = 0.2
        } else {
            buttonBackgroundView.layer.shadowOpacity = 0
        }
    }
}

// MARK: - Private methods

private extension ConsentActionView {

    @objc func buttonPressed(sender: UIButton) {
        guard let model = model else { return }
        delegate?.consentActionView(self, didPressButtonAt: model.indexPath)
    }

    func set(model: ConsentActionViewModel?) {
        guard let model = model else { return }
        textLabel.attributedText = model.text.attributedStringWithLineSpacing(lineSpacing)
        if button.style != model.buttonStyle {
            button.removeFromSuperview()
            button = newButton(with: model.buttonStyle)
            addSubview(button)
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
                button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing),
                button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing)
            ])
        }
        button.setTitle(model.buttonTitle, for: .normal)
    }

    func newButton(with style: Button.Style) -> Button {
        let button = Button(style: style)
        button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }

    func setupSubViews() {
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













