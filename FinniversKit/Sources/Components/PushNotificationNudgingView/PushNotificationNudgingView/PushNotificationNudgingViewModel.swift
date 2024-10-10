import Foundation
import SwiftUI

public enum PushNotificationNudgingState {
    case initialPrompt
    case tunedOff
    case allSet
}

public struct PushNotificationNudgingViewModel {
    let icon: Image
    let title: String
    let description: String?
    let state: PushNotificationNudgingState
    let layoutMarginsFollowReadableWidth: Bool
    let closeButtonAction: (() -> Void)?

    public init(
        icon: Image,
        title: String,
        description: String? = nil,
        state: PushNotificationNudgingState,
        layoutMarginsFollowReadableWidth: Bool = false,
        closeButtonAction: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.state = state
        self.layoutMarginsFollowReadableWidth = layoutMarginsFollowReadableWidth
        self.closeButtonAction = closeButtonAction
    }
}
