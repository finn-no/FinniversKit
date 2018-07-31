//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol AdReporterDelegate: RadioButtonDelegate {
    func adReporterViewHelpButtonPressed(_ adReporterView: AdReporterView)
}

public class AdReporterView: UIView {

    // MARK: - Private properties

    private lazy var radioButton: RadioButton = {
        let radioButton = RadioButton(frame: .zero)
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        return radioButton
    }()

    private lazy var hairlineView: UIView = {
        let line = UIView(frame: .zero)
        line.backgroundColor = .sardine
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()

    private lazy var descriptionView: DescriptionView = {
        let descriptionView = DescriptionView(frame: .zero)
        descriptionView.delegate = self
        descriptionView.textViewMinimumHeight = 147
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        return descriptionView
    }()

    private lazy var helpButton: Button = {
        let button = Button(style: .link)
        button.addTarget(self, action: #selector(helpButtonPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var contentView: UIView = {
        let content = UIView(frame: .zero)
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private var textViewShouldGrow = false

    // MARK: - Public properties

    public var model: AdReporterViewModel? {
        didSet {
            guard let model = model else { return }
            radioButton.title = model.radioButtonTitle
            radioButton.fields = model.radioButtonFields
            descriptionView.titleLabel.text = model.descriptionViewTitle
            descriptionView.textView.placeholderText = model.descriptionViewPlaceholderText
            helpButton.setTitle(model.helpButtonText, for: .normal)
        }
    }

    public var message: String {
        return descriptionView.textView.text
    }

    public weak var delegate: AdReporterDelegate? {
        didSet {
            radioButton.delegate = delegate
        }
    }

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)

        loadRadioImages()
        registerKeyboardEvents()
        setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    private func loadRadioImages() {
        var radioButtonSelected = [UIImage]()
        var radioButtonUnselected = [UIImage]()

        for i in 0 ..< 13 {
            if let image = UIImage(named: "radiobutton-select-\(i)", in: FinniversKit.bundle, compatibleWith: nil) {
                radioButtonSelected.append(image)
            }
        }

        for i in 0 ..< 10 {
            if let image = UIImage(named: "radiobutton-unselected-\(i)", in: FinniversKit.bundle, compatibleWith: nil) {
                radioButtonUnselected.append(image)
            }
        }

        radioButton.selectedImage = radioButtonSelected.last
        radioButton.selectedAnimationImages = radioButtonSelected
        radioButton.unselectedImage = radioButtonUnselected.last
        radioButton.unselectedAnimationImages = radioButtonUnselected
    }

    private func setupSubviews() {
        contentView.addSubview(radioButton)
        contentView.addSubview(hairlineView)
        contentView.addSubview(descriptionView)
        contentView.addSubview(helpButton)
        scrollView.addSubview(contentView)
        addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),

            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: widthAnchor),

            radioButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            radioButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            radioButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            hairlineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            hairlineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumLargeSpacing),
            hairlineView.topAnchor.constraint(equalTo: radioButton.bottomAnchor),
            hairlineView.heightAnchor.constraint(equalToConstant: 1),

            descriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionView.topAnchor.constraint(equalTo: hairlineView.bottomAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            helpButton.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: .mediumLargeSpacing),
            helpButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            helpButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -.mediumLargeSpacing),
        ])
    }

    private func registerKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }

    // MARK: - Actions

    @objc func helpButtonPressed(sender: UIButton) {
        endEditing(true)
        delegate?.adReporterViewHelpButtonPressed(self)
    }

    // MARK: - Keyboard Events

    @objc func keyboardWillShow(notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset = UIEdgeInsets(top: 0, leading: 0, bottom: keyboardFrame.height + scrollView.contentOffset.y, trailing: 0)

        let overlap = keyboardFrame.intersection(convert(contentView.frame, to: UIScreen.main.coordinateSpace))

        if overlap != .null {
            scrollView.contentOffset = CGPoint(x: 0, y: scrollView.contentSize.height - scrollView.bounds.height + scrollView.contentInset.bottom)
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.contentOffset = .zero
    }
}

// MARK: -

extension AdReporterView: UITextViewDelegate {

    // MARK: TextView Delegate

    public func textViewDidChange(_ textView: UITextView) {
        let deltaHeight = textView.intrinsicContentSize.height - textView.frame.height

        if deltaHeight > 0 {
            textViewShouldGrow = true
            scrollView.contentOffset.y += deltaHeight

        } else if deltaHeight < 0, textViewShouldGrow {
            if textView.intrinsicContentSize.height < descriptionView.textViewMinimumHeight {
                textViewShouldGrow = false
                scrollView.contentOffset.y += descriptionView.textViewMinimumHeight - textView.frame.height
                return
            }
            scrollView.contentOffset.y += textView.intrinsicContentSize.height - textView.frame.height
        }
    }
}
