import Foundation

public struct KeyboardNotificationInfo {
    public enum KeyboardAction {
        case willShow
        case willHide
    }

    public let animationOptions: UIView.AnimationOptions
    public let animationDuration: Double
    public let frameStart: CGRect?
    public let frameEnd: CGRect?
    public let action: KeyboardAction

    public init?(_ notification: Notification) {
        guard let keyboardAction = notification.keyboardNotificationAction, let userInfo = notification.userInfo else { return nil }
        action = keyboardAction

        if let animationCurve = userInfo[UIWindow.keyboardAnimationCurveUserInfoKey] as? NSNumber {
            animationOptions = UIView.AnimationOptions(rawValue: animationCurve.uintValue)
        } else {
            animationOptions = []
        }

        animationDuration = (userInfo[UIWindow.keyboardAnimationDurationUserInfoKey] as? Double) ?? 0
        frameStart = userInfo[UIWindow.keyboardFrameBeginUserInfoKey] as? CGRect
        frameEnd = userInfo[UIWindow.keyboardFrameEndUserInfoKey] as? CGRect
    }

    /// Calculate the total intersection between the keyboard and a view. The value returned
    /// will be between 0 and whatever intersection occurs. This is in case the user has
    /// an iPad with an external keyboard connected, which would've returned a negative value.
    public func keyboardFrameEndIntersectHeight(inView view: UIView) -> CGFloat {
        guard let windowHeight = view.window?.frame.size.height, let frameEnd = frameEnd else { return 0 }
        let keyboardHeight = frameEnd.size.height
        let frameInWindow = view.convert(view.bounds, to: nil)

        // Calculate the intersection between the keyboard and this view.
        let intersection = keyboardHeight - (windowHeight - frameInWindow.origin.y - frameInWindow.size.height)
        return max(0, intersection)
    }
}

// MARK: - Private extensions

private extension Notification {
    var keyboardNotificationAction: KeyboardNotificationInfo.KeyboardAction? {
        switch self.name {
        case UIResponder.keyboardWillHideNotification:
            return .willHide
        case UIResponder.keyboardWillShowNotification:
            return .willShow
        default:
            return nil
        }
    }
}
