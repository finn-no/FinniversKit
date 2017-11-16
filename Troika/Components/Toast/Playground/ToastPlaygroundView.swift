//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika

class ToastClass: NSObject, ToastViewDelegate {
    func didTapActionButton(button: UIButton, in toastView: ToastView) {
        print("Button tapped")
    }

    func didTap(toastView: ToastView) {
        print("Toast view tapped")
    }
}

public class ToastPlaygroundView: UIView, Injectable {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    public func setup() {
        backgroundColor = .white

        let delegate = ToastClass()

        let successToast = ToastView()
        let imageToast = ToastView()
        let errorToast = ToastView()
        let successButtonToast = ToastView(delegate: delegate)
        let errorButtonToast = ToastView(delegate: delegate)
        let animatedToast = ToastView(delegate: delegate)

        successToast.model = ToastDataModel.multiline
        imageToast.model = ToastDataModel.successImage
        errorToast.model = ToastDataModel.error
        successButtonToast.model = ToastDataModel.successButton
        errorButtonToast.model = ToastDataModel.errorButton
        animatedToast.model = ToastDataModel.success

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

        successToast.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        successToast.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        successToast.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true

        imageToast.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageToast.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageToast.topAnchor.constraint(equalTo: successToast.bottomAnchor, constant: 32).isActive = true

        errorToast.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        errorToast.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        errorToast.topAnchor.constraint(equalTo: imageToast.bottomAnchor, constant: 32).isActive = true

        successButtonToast.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        successButtonToast.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        successButtonToast.topAnchor.constraint(equalTo: errorToast.bottomAnchor, constant: 32).isActive = true

        errorButtonToast.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        errorButtonToast.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        errorButtonToast.topAnchor.constraint(equalTo: successButtonToast.bottomAnchor, constant: 32).isActive = true
    }
}
