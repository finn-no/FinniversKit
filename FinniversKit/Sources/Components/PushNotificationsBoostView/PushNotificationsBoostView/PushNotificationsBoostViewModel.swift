import Foundation
import SwiftUI

public struct PushNotificationsBoostViewModel {
    let icon: Image
    let title: String
    let description: String?
    let isClickable: Bool
    let isClosable: Bool
    let layoutMarginsFollowReadableWidth: Bool

    public var closeButtonAction: (() -> Void)?

    public init(
        icon: Image,
        title: String,
        description: String? = nil,
        isClickable: Bool = false,
        isClosable: Bool = false,
        layoutMarginsFollowReadableWidth: Bool = false
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.isClickable = isClickable
        self.isClosable = isClosable
        self.layoutMarginsFollowReadableWidth = layoutMarginsFollowReadableWidth
    }
}
