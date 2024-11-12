import Foundation
import SwiftUI

public enum PushNotificationNudgingState {
    case initialPrompt
    case turnedOff
    case allSet
}

public struct PushNotificationNudgingViewModel {
    let icon: Image
    let title: String
    let description: String?
    let linkDescription: AttributedString?
    let state: PushNotificationNudgingState
    let layoutMarginsFollowReadableWidth: Bool
    let linkAction: (() -> Void)?
    let closeButtonAction: (() -> Void)?

    public init(
        icon: Image,
        title: String,
        description: String? = nil,
        linkDescription: AttributedString? = nil,
        state: PushNotificationNudgingState,
        layoutMarginsFollowReadableWidth: Bool = false,
        linkAction: (() -> Void)? = nil,
        closeButtonAction: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.linkDescription = linkDescription
        self.state = state
        self.layoutMarginsFollowReadableWidth = layoutMarginsFollowReadableWidth
        self.linkAction = linkAction
        self.closeButtonAction = closeButtonAction
    }
}
