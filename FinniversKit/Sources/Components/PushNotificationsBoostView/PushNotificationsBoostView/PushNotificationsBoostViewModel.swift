import Foundation
import SwiftUI

public struct PushNotificationsBoostViewModel {
    let icon: Image
    let title: String
    let description: String?
    let isClosable: Bool
    let isSeparatorsHidden: Bool

    public var closeButtonAction: (() -> Void)?

    public init(icon: Image, title: String, description: String? = nil, isClosable: Bool = false, isSeparatorsHidden: Bool = false) {
        self.icon = icon
        self.title = title
        self.description = description
        self.isClosable = isClosable
        self.isSeparatorsHidden = isSeparatorsHidden
    }
}
