import Foundation
import SwiftUI

public struct PushNotificationsBoostViewModel {
    let icon: Image
    let title: String
    let description: String?
    let isSeparatorsHidden: Bool

    public init(icon: Image, title: String, description: String? = nil, isSeparatorsHidden: Bool = false) {
        self.icon = icon
        self.title = title
        self.description = description
        self.isSeparatorsHidden = isSeparatorsHidden
    }
}
