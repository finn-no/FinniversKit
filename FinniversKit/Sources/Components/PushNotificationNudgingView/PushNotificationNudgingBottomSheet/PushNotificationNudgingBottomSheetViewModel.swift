import SwiftUI

public struct PushNotificationNudgingBottomSheetViewModel {
    let title: String
    let sections: [Section]
    let buttons: [Button]

    public init(title: String, sections: [Section], buttons: [Button]) {
        self.title = title
        self.sections = sections
        self.buttons = buttons
    }

    public struct Section {
        let icon: Image
        let title: String?
        let description: String

        public init(icon: Image, title: String? = nil, description: String) {
            self.icon = icon
            self.title = title
            self.description = description
        }
    }

    public struct Button {
        public enum Kind: Hashable {
            case allow
            case notNow
        }

        let kind: Kind
        let title: String
        let action: (() -> Void)?

        public init(kind: Kind, title: String, action: (() -> Void)? = nil) {
            self.kind = kind
            self.title = title
            self.action = action
        }
    }


}

extension PushNotificationNudgingBottomSheetViewModel.Section: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(description)
    }
}

extension PushNotificationNudgingBottomSheetViewModel.Button: Hashable {
    public static func == (lhs: PushNotificationNudgingBottomSheetViewModel.Button, rhs: PushNotificationNudgingBottomSheetViewModel.Button) -> Bool {
        lhs.kind == rhs.kind && lhs.title == rhs.title
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(kind)
        hasher.combine(title)
    }
}
