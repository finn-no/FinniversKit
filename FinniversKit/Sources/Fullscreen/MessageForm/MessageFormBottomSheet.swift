//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol MessageFormBottomSheetDelegate: AnyObject {
    /// Called when the "send"-button was tapped
    func messageFormBottomSheet(_ form: MessageFormBottomSheet,
                                didFinishWithText text: String,
                                templateState: MessageFormTemplateState,
                                template: MessageFormTemplate?)

    /// Called after the MessageFormBottomSheet disappeared from view
    func messageFormBottomSheetDidDismiss(_ form: MessageFormBottomSheet)
}

public class MessageFormBottomSheet: BottomSheet {

    // MARK: - Public properties

    public weak var messageFormDelegate: MessageFormBottomSheetDelegate?

    public var inputEnabled: Bool {
        get { return messageFormViewController.inputEnabled }
        set { messageFormViewController.inputEnabled = newValue }
    }

    /// This view should be used if you wish to present a toast inside this view controller.
    public var toastPresenterView: UIView {
        return messageFormViewController.toastPresenterView
    }

    // MARK: - Private properties

    private let messageFormViewController: MessageFormViewController!
    private let rootController: UINavigationController!
    private let viewModel: MessageFormViewModel

    // MARK: - Init

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public required init(viewModel: MessageFormViewModel) {
        self.viewModel = viewModel
        messageFormViewController = MessageFormViewController(viewModel: viewModel)
        rootController = UINavigationController(rootViewController: messageFormViewController)
        rootController.navigationBar.isTranslucent = false
        rootController.navigationBar.barTintColor = .bgPrimary

        super.init(rootViewController: rootController, height: .messageFormHeight, draggableArea: .navigationBar)

        messageFormViewController.delegate = self
        delegate = self
    }

    // MARK: - Private methods

    private func dismissWithConfirmationIfNeeded() {
        if canDismissWithoutConfirmation() {
            state = .dismissed
        } else {
            dismissWithConfirmation()
        }
    }

    private func canDismissWithoutConfirmation() -> Bool {
        return !messageFormViewController.hasUncommittedChanges
    }

    private func dismissWithConfirmation() {
        let alertStyle: UIAlertController.Style = UIDevice.isIPad() ? .alert : .actionSheet

        let alertController = UIAlertController(title: viewModel.cancelFormAlertTitle,
                                                message: viewModel.cancelFormAlertMessage,
                                                preferredStyle: alertStyle)

        let cancelAction = UIAlertAction(title: viewModel.cancelFormAlertCancelText, style: .cancel, handler: nil)
        let dismissAction = UIAlertAction(title: viewModel.cancelFormAlertActionText, style: .destructive, handler: { [weak self] _ in
            self?.state = .dismissed
        })

        alertController.addAction(cancelAction)
        alertController.addAction(dismissAction)

        present(alertController, animated: true)
    }
}

extension MessageFormBottomSheet: MessageFormViewControllerDelegate {
    func messageFormViewControllerDidCancel(_ viewController: MessageFormViewController) {
        dismissWithConfirmationIfNeeded()
    }

    func messageFormViewController(_ viewController: MessageFormViewController, didFinishWithText text: String, templateState: MessageFormTemplateState, template: MessageFormTemplate?) {
        messageFormDelegate?.messageFormBottomSheet(self, didFinishWithText: text, templateState: templateState, template: template)
    }
}

extension MessageFormBottomSheet: BottomSheetDelegate {
    public func bottomSheetShouldDismiss(_ bottomSheet: BottomSheet) -> Bool {
        return canDismissWithoutConfirmation()
    }

    public func bottomSheetDidCancelDismiss(_ bottomSheet: BottomSheet) {
        dismissWithConfirmation()
    }

    public func bottomSheet(_ bottomSheet: BottomSheet, willDismissBy action: BottomSheet.DismissAction) {
        return
    }

    public func bottomSheet(_ bottomSheet: BottomSheet, didDismissBy action: BottomSheet.DismissAction) {
        messageFormDelegate?.messageFormBottomSheetDidDismiss(self)
    }
}

// MARK: - Private extensions

private extension BottomSheet.Height {
    static var messageFormHeight: BottomSheet.Height {
        let screenSize = UIScreen.main.bounds.size
        let height = screenSize.height - 64
        return BottomSheet.Height(compact: height, expanded: height)
    }
}
