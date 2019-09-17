//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class ToastDemoView: UIView {
    private lazy var topToastButton: Button = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Animate From Top", for: .normal)
        button.addTarget(self, action: #selector(animateFromTop), for: .touchUpInside)
        return button
    }()

    private lazy var bottomToastButton: Button = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Animate From Bottom", for: .normal)
        button.addTarget(self, action: #selector(animateFromBottom), for: .touchUpInside)
        return button
    }()

    private lazy var containerView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .toothPaste
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()

    private lazy var containedToastButton: Button = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Animate In Container", for: .normal)
        button.addTarget(self, action: #selector(animateInContainer), for: .touchUpInside)
        return button
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.spacing = .mediumLargeSpacing
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        let successToast = ToastView(style: .success)
        successToast.text = "Success"

        let attributedTextSuccessToast = ToastView(style: .success)
        attributedTextSuccessToast.attributedText = {
            let attributedString = NSMutableAttributedString(string: "What do we want? ", attributes: [.font: UIFont.body, .foregroundColor: UIColor.licorice])
            attributedString.append(NSAttributedString(string: "Attributed strings!", attributes: [.font: UIFont.bodyStrong, .foregroundColor: UIColor.licorice]))
            return attributedString
        }()

        let imageToast = ToastView(style: .sucesssWithImage)
        imageToast.text = "Image success"

        let errorToast = ToastView(style: .error)
        errorToast.text = "Error"

        let successButtonToast = ToastView(style: .successButton)
        successButtonToast.text = "Action success"
        successButtonToast.action = ToastAction(title: "Action") {
            print("Action button tapped")
        }

        let errorButtonToast = ToastView(style: .errorButton)
        errorButtonToast.text = "Action error"
        errorButtonToast.action = ToastAction(title: "Undo") {
            print("Undo button tapped")
        }

        let successPromotedButtonToast = ToastView(style: .successButton, buttonStyle: .promoted)
        successPromotedButtonToast.text = "Action success"
        successPromotedButtonToast.action = ToastAction(title: "Action") {
            print("Promoted action button tapped")
        }

        let errorPromotedButtonToast = ToastView(style: .errorButton, buttonStyle: .promoted)
        errorPromotedButtonToast.text = "Action error"
        errorPromotedButtonToast.action = ToastAction(title: "Undo") {
            print("Promoted undo button tapped")
        }

        stackView.addArrangedSubview(successToast)
        stackView.addArrangedSubview(attributedTextSuccessToast)
        stackView.addArrangedSubview(imageToast)
        stackView.addArrangedSubview(errorToast)
        stackView.addArrangedSubview(errorButtonToast)
        stackView.addArrangedSubview(successPromotedButtonToast)
        stackView.addArrangedSubview(errorPromotedButtonToast)

        addSubview(stackView)
        addSubview(topToastButton)
        addSubview(bottomToastButton)

        addSubview(containerView)
        containerView.addSubview(containedToastButton)

        directionalLayoutMargins = NSDirectionalEdgeInsets(all: .mediumLargeSpacing)


        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),

            topToastButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            topToastButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            topToastButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: .mediumLargeSpacing),

            bottomToastButton.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            bottomToastButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            bottomToastButton.topAnchor.constraint(equalTo: topToastButton.bottomAnchor, constant: .mediumLargeSpacing),

            containerView.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            containerView.topAnchor.constraint(equalTo: bottomToastButton.bottomAnchor, constant: .mediumLargeSpacing),

            containedToastButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .mediumLargeSpacing),
            containedToastButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.mediumLargeSpacing),
            containedToastButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: .mediumLargeSpacing),
            containedToastButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -.veryLargeSpacing)
        ])
    }

    @objc private func animateFromTop() {
        // Because the demo views only fill the view controller's safe area, we need to display the toast
        // in the superview (the view controller) to make the toast fill the safe area inset.
        guard let superview = superview else { return }
        animateSuccess(in: superview, fromBottom: false)
    }

    @objc private func animateFromBottom() {
        // Because the demo views only fill the view controller's safe area, we need to display the toast
        // in the superview (the view controller) to make the toast fill the safe area inset.
        guard let superview = superview else { return }
        animateSuccess(in: superview)
    }

    @objc private func animateInContainer() {
        animateSuccess(in: containerView)
    }

    private func animateSuccess(in toastPresenterView: UIView, fromBottom: Bool = true) {
        let animatedToast = ToastView(style: .success)
        animatedToast.text = "Animated success"
        if fromBottom {
            animatedToast.presentFromBottom(view: toastPresenterView, animateOffset: 0, timeOut: 3)
        } else {
            animatedToast.presentFromTop(view: toastPresenterView, animateOffset: 0, timeOut: 3)
        }
    }
}
