//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Munch
import UIKit

class ToastClass: NSObject, ToastViewDelegate {
    func didTapActionButton(button: UIButton, in toastView: ToastView) {
        print("Button tapped \(toastView.style)")
    }

    func didTap(toastView: ToastView) {
        print("Toast view tapped \(toastView.style)")
    }
}

public class ToastDemoView: UIView {
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
        let animatedToast = ToastView(style: .success)

        successToast.text = "Success"
        imageToast.text = "Image success"
        errorToast.text = "Error"
        successButtonToast.text = "Action success"
        successButtonToast.buttonText = "Action"
        errorButtonToast.text = "Action error"
        errorButtonToast.buttonText = "Undo"
        animatedToast.text = "Animated success"

        successButtonToast.delegate = delegate
        errorButtonToast.delegate = delegate
        animatedToast.delegate = delegate

        animatedToast.presentFromBottom(view: self, animateOffset: 0, timeOut: 5)

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

        NSLayoutConstraint.activate([
            successToast.leadingAnchor.constraint(equalTo: leadingAnchor),
            successToast.trailingAnchor.constraint(equalTo: trailingAnchor),
            successToast.topAnchor.constraint(equalTo: topAnchor, constant: 16),

            imageToast.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageToast.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageToast.topAnchor.constraint(equalTo: successToast.bottomAnchor, constant: 32),

            errorToast.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorToast.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorToast.topAnchor.constraint(equalTo: imageToast.bottomAnchor, constant: 32),

            successButtonToast.leadingAnchor.constraint(equalTo: leadingAnchor),
            successButtonToast.trailingAnchor.constraint(equalTo: trailingAnchor),
            successButtonToast.topAnchor.constraint(equalTo: errorToast.bottomAnchor, constant: 32),

            errorButtonToast.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorButtonToast.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorButtonToast.topAnchor.constraint(equalTo: successButtonToast.bottomAnchor, constant: 32),
        ])
    }
}
