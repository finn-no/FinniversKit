//
//  Copyright © 2018 FINN AS. All rights reserved.
//
import UIKit

public protocol ConsentDetailViewDelegate: class {
    func consentDetailView(_ consentDetailView: ConsentDetailView, didToggleSwitch position: Bool)
    func readMoreButtonPressed(in consentDetailView: ConsentDetailView)
}

public class ConsentDetailView: UIView {

    // MARK: - Private properties

    private lazy var textView: Label = {
        let label = Label(style: .body)
        label.textColor = .stone
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var switchLabel: Label = {
        let label = Label(style: .body)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var theSwitch: UISwitch = {
        let view = UISwitch(frame: .zero)
        view.onTintColor = .pea
        view.addTarget(self, action: #selector(switchDidToogle(sender:)), for: .valueChanged)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var readMoreButton: Button = {
        let button = Button(style: .flat)
        button.addTarget(self, action: #selector(readMoreButtonPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView(frame: .zero)
        scroll.alwaysBounceVertical = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    // MARK: - Public properties

    public var model: ConsentDetailViewModel? {
        didSet { set(model: model) }
    }

    public var buttonTitle: String? {
        didSet { readMoreButton.setTitle(buttonTitle, for: .normal) }
    }

    public weak var delegate: ConsentDetailViewDelegate?

    public var state: Bool = false {
        didSet { theSwitch.setOn(state, animated: false) }
    }

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

private extension ConsentDetailView {
    func setupSubviews() {
        addSubview(scrollView)
        scrollView.addSubview(textView)
        scrollView.addSubview(switchLabel)
        scrollView.addSubview(theSwitch)
        scrollView.addSubview(readMoreButton)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.widthAnchor.constraint(equalTo: widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: heightAnchor),

            switchLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .mediumLargeSpacing),
            switchLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: .largeSpacing),
            switchLabel.trailingAnchor.constraint(lessThanOrEqualTo: theSwitch.leadingAnchor, constant: .mediumSpacing),

            theSwitch.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            theSwitch.centerYAnchor.constraint(equalTo: switchLabel.centerYAnchor),

            textView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: .mediumLargeSpacing),
            textView.topAnchor.constraint(equalTo: switchLabel.bottomAnchor, constant: .largeSpacing),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            readMoreButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            readMoreButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: .mediumLargeSpacing + .smallSpacing),

            scrollView.bottomAnchor.constraint(equalTo: readMoreButton.bottomAnchor, constant: .mediumLargeSpacing)
        ])
    }

    func set(model: ConsentDetailViewModel?) {
        guard let model = model else { return }
        textView.attributedText = model.definition.attributedStringWithLineSpacing(4)
        switchLabel.text = model.switchTitle
    }

    @objc func switchDidToogle(sender: UISwitch) {
        delegate?.consentDetailView(self, didToggleSwitch: sender.isOn)
    }
    @objc func readMoreButtonPressed(sender: UIButton) {
        delegate?.readMoreButtonPressed(in: self)
    }

}
