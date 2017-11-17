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

public class ToastPlayground: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {

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

        NSLayoutConstraint.activate([
            successToast.leadingAnchor.constraint(equalTo: leadingAnchor),
            successToast.trailingAnchor.constraint(equalTo: trailingAnchor),
            successToast.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),

            imageToast.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageToast.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageToast.topAnchor.constraint(equalTo: successToast.bottomAnchor, constant: .largeSpacing),

            errorToast.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorToast.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorToast.topAnchor.constraint(equalTo: imageToast.bottomAnchor, constant: .largeSpacing),

            successButtonToast.leadingAnchor.constraint(equalTo: leadingAnchor),
            successButtonToast.trailingAnchor.constraint(equalTo: trailingAnchor),
            successButtonToast.topAnchor.constraint(equalTo: errorToast.bottomAnchor, constant: .largeSpacing),

            errorButtonToast.leadingAnchor.constraint(equalTo: leadingAnchor),
            errorButtonToast.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorButtonToast.topAnchor.constraint(equalTo: successButtonToast.bottomAnchor, constant: .largeSpacing),
        ])
    }
}
