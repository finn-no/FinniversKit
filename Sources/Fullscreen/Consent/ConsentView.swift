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
    private var switchBackgroundView: UIView?

    private lazy var textLabel: Label = {
        let label = Label(style: .body)
        label.textColor = .stone
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var button: Button = buttonWith(style: .flat)
    private var buttonBackgroundView: UIView?

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: .zero)
        scroll.alwaysBounceVertical = true
        scroll.delegate = self
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    // Used to controll the size of the scroll view when the button is moved to the bottom
    private lazy var sizeView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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

    public override func layoutSubviews() {
        super.layoutSubviews()
        guard let view = buttonBackgroundView, textLabel.intrinsicContentSize.height >= view.frame.minY else { return }
        buttonBackgroundView?.layer.shadowOpacity = 0.2
    }

}

extension ConsentView: UIScrollViewDelegate {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let view = buttonBackgroundView else { return }
        if -scrollView.contentOffset.y + textLabel.intrinsicContentSize.height + .largeSpacing > view.frame.minY {
            self.buttonBackgroundView?.layer.shadowOpacity = 0.2
        } else {
            self.buttonBackgroundView?.layer.shadowOpacity = 0
        }
    }
}

// MARK: - Private functions

private extension ConsentView {
    func setupScrollView() {
        addSubview(sizeView)
        addSubview(scrollView)

        let sizeBottomConstraints = sizeView.bottomAnchor.constraint(equalTo: bottomAnchor)
        sizeBottomConstraints.priority = .defaultHigh

        NSLayoutConstraint.activate([
            sizeView.leadingAnchor.constraint(equalTo: leadingAnchor),
            sizeView.topAnchor.constraint(equalTo: topAnchor),
            sizeView.trailingAnchor.constraint(equalTo: trailingAnchor),
            sizeBottomConstraints,

            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: sizeView.heightAnchor)
        ])
    }

    func set(model: ConsentViewModel?) {
        guard let model = model else { return }

        var aboveAnchor = scrollView.topAnchor
        if let title = model.title {
            let view = addSwitchView(with: title, and: model.state)
            aboveAnchor = view.bottomAnchor
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

            scrollView.bottomAnchor.constraint(greaterThanOrEqualTo: button.bottomAnchor, constant: .mediumLargeSpacing)
        ])

        guard model.buttonStyle != .flat else { return }
        changeButton(to: model.buttonStyle, with: model.buttonTitle)
    }

    func addSwitchView(with title: String, and state: Bool) -> UIView {
        let backgroundView = UIView(frame: .zero)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .ice

        let label = titleLabel(with: title)
        let localSwitch = switchWithTarget(state: state)

        scrollView.addSubview(backgroundView)
        scrollView.addSubview(label)
        scrollView.addSubview(localSwitch)

        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            backgroundView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 24),

            label.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .mediumLargeSpacing),
            label.trailingAnchor.constraint(lessThanOrEqualTo: localSwitch.leadingAnchor, constant: -.mediumSpacing),

            localSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            localSwitch.centerYAnchor.constraint(equalTo: label.centerYAnchor)
            ])

        titleLabel = label
        _switch = localSwitch
        switchBackgroundView = backgroundView
        return backgroundView
    }

    func changeButton(to style: Button.Style, with title: String) {
        button.removeFromSuperview()

        let backgroundView = UIView(frame: .zero)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = .milk
        backgroundView.layer.shadowOffset = .zero

        let _button = buttonWith(style: style)
        _button.setTitle(title, for: .normal)

        addSubview(backgroundView)
        backgroundView.addSubview(_button)
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: _button.topAnchor, constant: -.mediumLargeSpacing),

            _button.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: .mediumLargeSpacing),
            _button.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -.mediumLargeSpacing),
            _button.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -.mediumLargeSpacing),

            sizeView.bottomAnchor.constraint(equalTo: backgroundView.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: .mediumLargeSpacing),
            ])

        button = _button
        buttonBackgroundView = backgroundView
    }

    func titleLabel(with text: String) -> Label {
        let label = Label(style: .body)
        label.text = text
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    func switchWithTarget(state: Bool) -> UISwitch {
        let view = UISwitch(frame: .zero)
        view.onTintColor = .pea
        view.setOn(state, animated: false)
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
