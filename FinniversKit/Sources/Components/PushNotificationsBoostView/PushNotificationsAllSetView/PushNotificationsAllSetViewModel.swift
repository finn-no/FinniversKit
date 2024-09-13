import Foundation
import SwiftUI

public struct PushNotificationsAllSetViewModel {
    let icon: Image
    let title: String

    public init(icon: Image, title: String) {
        self.icon = icon
        self.title = title
    }
}
