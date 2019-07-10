//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class ToastClass: NSObject, ToastViewDelegate {
    func didTapActionButton(button: UIButton, in toastView: ToastView) {
        print("Button tapped \(toastView.style)")
    }

    func didTap(toastView: ToastView) {
        print("Toast view tapped \(toastView.style)")
    }
}

public class ToastDemoView: UIView {
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

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }
    let delegate = ToastClass()

    private func setup() {
        let successToast = ToastView(style: .success)
        let imageToast = ToastView(style: .sucesssWithImage)
        let errorToast = ToastView(style: .error)
        let successButtonToast = ToastView(style: .successButton)
        let errorButtonToast = ToastView(style: .errorButton)

        successToast.text = "Success"
        imageToast.text = "Image success"
        errorToast.text = "Error"
        successButtonToast.text = "Action success"
        successButtonToast.buttonText = "Action"
        errorButtonToast.text = "Action error"
        errorButtonToast.buttonText = "Undo"

        successButtonToast.delegate = delegate
        errorButtonToast.delegate = delegate

        successToast.translatesAutoresizingMaskIntoConstraints = false
        imageToast.translatesAutoresizingMaskIntoConstraints = false
        errorToast.translatesAutoresizingMaskIntoConstraints = false
        successButtonToast.translatesAutoresizingMaskIntoConstraints = false
        errorButtonToast.translatesAutoresizingMaskIntoConstraints = false

        addSubview(successToast)
        addSubview(imageToast)
        addSubview(errorToast)
        addSubview(successButtonToast)
        addSubview(errorButtonToast)
        addSubview(bottomToastButton)

        addSubview(containerView)
        containerView.addSubview(containedToastButton)

        NSLayoutConstraint.activate([
            successToast.leadingAnchor.constraint(equalTo: leadingAnchor),
            successToast.trailingAnchor.constraint(equalTo: trailingAnchor),
            successToast.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),

            imageToast.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageToast.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageToast.topAnchor.constraint(equalTo: successToast.bottomAnchor, constant: .mediumLargeSpacing),

            errorToast.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorToast.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorToast.topAnchor.constraint(equalTo: imageToast.bottomAnchor, constant: .mediumLargeSpacing),

            successButtonToast.leadingAnchor.constraint(equalTo: leadingAnchor),
            successButtonToast.trailingAnchor.constraint(equalTo: trailingAnchor),
            successButtonToast.topAnchor.constraint(equalTo: errorToast.bottomAnchor, constant: .mediumLargeSpacing),

            errorButtonToast.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorButtonToast.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorButtonToast.topAnchor.constraint(equalTo: successButtonToast.bottomAnchor, constant: .mediumLargeSpacing),

            bottomToastButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            bottomToastButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            bottomToastButton.topAnchor.constraint(equalTo: errorButtonToast.bottomAnchor, constant: .mediumLargeSpacing),

            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            containerView.topAnchor.constraint(equalTo: bottomToastButton.bottomAnchor, constant: .mediumLargeSpacing),

            containedToastButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: .mediumLargeSpacing),
            containedToastButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -.mediumLargeSpacing),
            containedToastButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: .mediumLargeSpacing),
            containedToastButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -.veryLargeSpacing)
        ])
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

    private func animateSuccess(in toastPresenterView: UIView) {
        let animatedToast = ToastView(style: .success)
        animatedToast.text = "Animated success"
        animatedToast.delegate = delegate
        animatedToast.presentFromBottom(view: toastPresenterView, animateOffset: 0, timeOut: 5)
    }
}
