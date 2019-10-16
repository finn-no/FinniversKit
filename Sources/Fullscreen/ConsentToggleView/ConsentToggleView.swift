//
//  Copyright © 2018 FINN AS. All rights reserved.
//
import UIKit

public protocol ConsentToggleViewDelegate: AnyObject {
    func consentToggleView(_ consentToggleView: ConsentToggleView, didToggleSwitch position: Bool)
    func consentToggleViewDidPressButton(_ consentToggleView: ConsentToggleView)
}

public class ConsentToggleView: UIView {
    // MARK: - Private properties

    private var titleLabel: Label = {
        let label = Label(style: .body)
        label.textColor = .textSecondary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var toggle: UISwitch = {
        let toggle = UISwitch(withAutoLayout: true)
        toggle.onTintColor = .btnPrimary
        toggle.addTarget(self, action: #selector(switchDidToogle(sender:)), for: .valueChanged)
        return toggle
    }()

    private var backgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .bgSecondary
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var textLabel: Label = {
        let label = Label(style: .body)
        label.textColor = .textSecondary
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var button: Button = {
        let button = Button(style: .flat)
        button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var contentView: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: .zero)
        scroll.alwaysBounceVertical = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    // MARK: - Public properties

    public var model: ConsentToggleViewModel? {
        didSet { set(model: model) }
    }

    public weak var delegate: ConsentToggleViewDelegate?

    public var lineSpacing: CGFloat = 4

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func setOn(_ on: Bool, animated: Bool = false) {
        toggle.setOn(on, animated: animated)
        model?.state = on
    }
}

// MARK: - Private methods

private extension ConsentToggleView {
    @objc func switchDidToogle(sender: UISwitch) {
        model?.state = sender.isOn
        delegate?.consentToggleView(self, didToggleSwitch: sender.isOn)
    }

    @objc func buttonPressed(sender: UIButton) {
        delegate?.consentToggleViewDidPressButton(self)
    }

    func set(model: ConsentToggleViewModel?) {
        guard let model = model else { return }
        titleLabel.text = model.title
        toggle.setOn(model.state, animated: false)
        textLabel.attributedText = model.text.attributedStringWithLineSpacing(lineSpacing)
        button.setTitle(model.buttonTitle, for: .normal)
        guard model.buttonTitle == nil else { return }
        button.isHidden = true
    }

    func setup() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(backgroundView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(toggle)
        contentView.addSubview(textLabel)
        contentView.addSubview(button)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            backgroundView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumLargeSpacing + .mediumSpacing),

            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumLargeSpacing + .mediumSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: toggle.leadingAnchor, constant: -.mediumSpacing),

            toggle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            toggle.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),

            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            textLabel.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: .largeSpacing),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),

            button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            button.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: .largeSpacing),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumLargeSpacing)
        ])
    }
}
