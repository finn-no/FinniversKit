//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class ReportAdView: UIView {

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
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        descriptionView.textViewMinimumHeight = 147
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
        scrollView.alwaysBounceVertical = true
        scrollView.keyboardDismissMode = .interactive
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private var shouldScrollDown = false

    // MARK: - Public properties

    public var model: ReportAdViewModel? {
        didSet {
            guard let model = model else { return }
            radioButton.title = model.radioButtonTitle
            radioButton.fields = model.radioButtonFields
            descriptionView.title = model.descriptionViewTitle
            descriptionView.placeholderText = model.descriptionViewPlaceholderText
            helpButton.setTitle(model.helpButtonText, for: .normal)
        }
    }

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)

        let framesPerSecond = 60.0

        let radiobuttonSelected = UIImage.animatedImageNamed("radiobutton-select-", duration: 13 / framesPerSecond)
        let radiobuttonUnselected = UIImage.animatedImageNamed("radiobutton-unselected-", duration: 10 / framesPerSecond)

        radioButton.selectedImage = radiobuttonSelected?.images?.last
        radioButton.selectedAnimationImages = radiobuttonSelected?.images
        radioButton.unselectedImage = radiobuttonUnselected?.images?.last
        radioButton.unselectedAnimationImages = radiobuttonUnselected?.images

        registerKeyboardEvents()
        setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
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
    }
}

extension ReportAdView: UITextViewDelegate {
    public func textViewDidChange(_ textView: UITextView) {
        if textView.intrinsicContentSize.height > textView.frame.height {
            shouldScrollDown = true
            scrollView.contentOffset.y += textView.intrinsicContentSize.height - textView.frame.height

        } else if textView.intrinsicContentSize.height < textView.frame.height, shouldScrollDown {
            if textView.intrinsicContentSize.height < descriptionView.textViewMinimumHeight {
                shouldScrollDown = false
                scrollView.contentOffset.y += descriptionView.textViewMinimumHeight - textView.frame.height
                return
            }
            scrollView.contentOffset.y += textView.intrinsicContentSize.height - textView.frame.height
        }
    }
}
