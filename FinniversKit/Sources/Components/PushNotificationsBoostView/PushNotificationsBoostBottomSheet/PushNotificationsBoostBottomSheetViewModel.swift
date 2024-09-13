import SwiftUI

public struct PushNotificationsBoostBottomSheetViewModel {
    let dismiss: (() -> Void)?
    let title: String
    let cancelButtonTitle: String?
    let sections: [Section]
    let buttons: [Button]

    public init(title: String, cancelButtonTitle: String? = nil, dismiss: (() -> Void)? = nil, sections: [Section], buttons: [Button]) {
        self.dismiss = dismiss
        self.title = title
        self.cancelButtonTitle = cancelButtonTitle
        self.sections = sections
        self.buttons = buttons
    }

    public struct Section {
        let icon: Image
        let title: String
        let description: String

        public init(icon: Image, title: String, description: String) {
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

        public var action: ((Kind) -> Void)?

        let kind: Kind
        let title: String

        public init(kind: Kind, title: String) {
            self.kind = kind
            self.title = title
        }

        func handle(_ kind: Kind) {
            action?(kind)
        }
    }


}

extension PushNotificationsBoostBottomSheetViewModel.Section: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(description)
    }
}

extension PushNotificationsBoostBottomSheetViewModel.Button: Hashable {
    public static func == (lhs: PushNotificationsBoostBottomSheetViewModel.Button, rhs: PushNotificationsBoostBottomSheetViewModel.Button) -> Bool {
        lhs.kind == rhs.kind && lhs.title == rhs.title
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(kind)
        hasher.combine(title)
    }
}
