import SwiftUI

public struct PushNotificationsBoostBottomSheetViewModel {
    public struct Section {
        let icon: Image
        let title: String
        let description: String
    }

    public struct Button {
        var action: ((Kind) -> Void)?

        let kind: Kind
        let title: String

        public enum Kind: Hashable {
            case allow
            case notNow
        }

        func handle(_ kind: Kind) {
            action?(kind)
        }
    }

    let title: String
    let sections: [Section]
    let buttons: [Button]

    public init(title: String, sections: [Section], buttons: [Button]) {
        self.title = title
        self.sections = sections
        self.buttons = buttons
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
