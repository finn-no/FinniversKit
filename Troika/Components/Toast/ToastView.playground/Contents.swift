import UIKit
import PlaygroundSupport
import Troika
import TroikaDemoKit

TroikaDemoKit.setupPlayground()

let view = UIView()

view.backgroundColor = .white
view.frame = ScreenSize.medium

class ToastClass: NSObject, ToastViewDelegate {
    func didTap(button: UIButton, in toastView: ToastView) {
        print("Button tapped")
    }
}

let delegate = ToastClass()

let successToast = ToastView()
let imageToast = ToastView()
let errorToast = ToastView()
let buttonToast = ToastView(delegate: delegate)
let animatedToast = ToastView()

successToast.presentable = ToastDataModel.multiline
imageToast.presentable = ToastDataModel.successImage
errorToast.presentable = ToastDataModel.error
buttonToast.presentable = ToastDataModel.button
animatedToast.presentable = ToastDataModel.success

animatedToast.animateFromBottom(view: view, animateOffset: 0)

successToast.translatesAutoresizingMaskIntoConstraints = false
imageToast.translatesAutoresizingMaskIntoConstraints = false
errorToast.translatesAutoresizingMaskIntoConstraints = false
buttonToast.translatesAutoresizingMaskIntoConstraints = false

view.addSubview(successToast)
view.addSubview(imageToast)
view.addSubview(errorToast)
view.addSubview(buttonToast)

successToast.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
successToast.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
successToast.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true

imageToast.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
imageToast.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
imageToast.topAnchor.constraint(equalTo: successToast.bottomAnchor, constant: 32).isActive = true

errorToast.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
errorToast.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
errorToast.topAnchor.constraint(equalTo: imageToast.bottomAnchor, constant: 32).isActive = true

buttonToast.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
buttonToast.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
buttonToast.topAnchor.constraint(equalTo: errorToast.bottomAnchor, constant: 32).isActive = true

PlaygroundPage.current.liveView = view
