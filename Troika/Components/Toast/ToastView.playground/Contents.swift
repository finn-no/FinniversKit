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
        print("Button tapped")
    }
    
    func didTap(toastView: ToastView) {
        print("Toast view tapped")
    }
}

let delegate = ToastClass()

let successToast = ToastView()
let imageToast = ToastView()
let errorToast = ToastView()
let successButtonToast = ToastView(delegate: delegate)
let errorButtonToast = ToastView(delegate: delegate)
let animatedToast = ToastView(delegate: delegate)

successToast.presentable = ToastDataModel.multiline
imageToast.presentable = ToastDataModel.successImage
errorToast.presentable = ToastDataModel.error
successButtonToast.presentable = ToastDataModel.successButton
errorButtonToast.presentable = ToastDataModel.errorButton
animatedToast.presentable = ToastDataModel.success

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

successToast.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
successToast.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
successToast.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true

imageToast.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
imageToast.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
imageToast.topAnchor.constraint(equalTo: successToast.bottomAnchor, constant: 32).isActive = true

errorToast.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
errorToast.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
errorToast.topAnchor.constraint(equalTo: imageToast.bottomAnchor, constant: 32).isActive = true

successButtonToast.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
successButtonToast.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
successButtonToast.topAnchor.constraint(equalTo: errorToast.bottomAnchor, constant: 32).isActive = true

errorButtonToast.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
errorButtonToast.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
errorButtonToast.topAnchor.constraint(equalTo: successButtonToast.bottomAnchor, constant: 32).isActive = true

PlaygroundPage.current.liveView = view
