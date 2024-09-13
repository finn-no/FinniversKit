import Foundation
import SwiftUI

public struct PushNotificationsBoostViewModel {
    let icon: Image
    let title: String
    let description: String?

    public init(icon: Image, title: String, description: String? = nil) {
        self.icon = icon
        self.title = title
        self.description = description
    }
}
