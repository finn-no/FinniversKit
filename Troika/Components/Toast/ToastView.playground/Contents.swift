//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import PlaygroundSupport
import Troika
import TroikaDemoKit

TroikaDemoKit.setupPlayground()

let view = UIView()

view.backgroundColor = .white
view.frame = ScreenSize.medium

class ToastClass: NSObject, ToastViewDelegate {
    func didTapActionButton(button: UIButton, in toastView: ToastView) {
        print("Button tapped in \(toastView.style)")
    }

    func didTap(toastView: ToastView) {
        print("Toast view tapped in \(toastView.style)")
    }
}

let delegate = ToastClass()

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

animatedToast.presentFromBottom(view: view, animateOffset: 0, timeOut: 5)

successToast.translatesAutoresizingMaskIntoConstraints = false
imageToast.translatesAutoresizingMaskIntoConstraints = false
errorToast.translatesAutoresizingMaskIntoConstraints = false
successButtonToast.translatesAutoresizingMaskIntoConstraints = false
errorButtonToast.translatesAutoresizingMaskIntoConstraints = false

view.addSubview(successToast)
view.addSubview(imageToast)
view.addSubview(errorToast)
view.addSubview(successButtonToast)
view.addSubview(errorButtonToast)

successToast.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
successToast.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
successToast.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true

imageToast.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
imageToast.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
imageToast.topAnchor.constraint(equalTo: successToast.bottomAnchor, constant: 32).isActive = true

errorToast.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
errorToast.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
errorToast.topAnchor.constraint(equalTo: imageToast.bottomAnchor, constant: 32).isActive = true

successButtonToast.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
successButtonToast.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
successButtonToast.topAnchor.constraint(equalTo: errorToast.bottomAnchor, constant: 32).isActive = true

errorButtonToast.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
errorButtonToast.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
errorButtonToast.topAnchor.constraint(equalTo: successButtonToast.bottomAnchor, constant: 32).isActive = true

PlaygroundPage.current.liveView = view
