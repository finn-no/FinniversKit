//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol MessageFormBottomSheetDelegate: AnyObject {
    func messageFormBottomSheetDidCancel(_ form: MessageFormBottomSheet)
    func messageFormBottomSheet(_ form: MessageFormBottomSheet, didFinishWithText text: String, templateState: MessageFormTemplateState)
}

public class MessageFormBottomSheet: BottomSheet {

    // MARK: - Public properties

    public weak var messageFormDelegate: MessageFormBottomSheetDelegate?

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

    func messageFormViewController(_ viewController: MessageFormViewController, didFinishWithText text: String, templateState: MessageFormTemplateState) {
        messageFormDelegate?.messageFormBottomSheet(self, didFinishWithText: text, templateState: templateState)
    }
}

extension MessageFormBottomSheet: BottomSheetDelegate {
    public func bottomSheetShouldDismiss(_ bottomSheet: BottomSheet) -> Bool {
        return canDismissWithoutConfirmation()
    }

    public func bottomSheetDidCancelDismiss(_ bottomSheet: BottomSheet) {
        dismissWithConfirmation()
    }

    public func bottomSheet(_ bottomSheet: BottomSheet, didDismissBy action: BottomSheet.DismissAction) {

    }
}

// MARK: - Private extensions

private extension BottomSheet.Height {
    static var messageFormHeight: BottomSheet.Height {
        let screenSize = UIScreen.main.bounds.size

        if screenSize.height <= 568 {
            return BottomSheet.Height(compact: 510, expanded: 510)
        }

        let height = screenSize.height - 64

        return BottomSheet.Height(compact: height, expanded: height)
    }
}
