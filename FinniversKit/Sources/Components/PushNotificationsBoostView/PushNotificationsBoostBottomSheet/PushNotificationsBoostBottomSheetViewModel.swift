import SwiftUI

public struct PushNotificationsBoostBottomSheetViewModel {
    public struct SectionViewModel {
        let icon: Image
        let title: String
        let description: String
    }

    public struct Button {
        let kind: Kind
        let title: String

        public enum Kind {
            case allow
            case notNow
        }
    }

    let title: String
    let sections: [SectionViewModel]
    let buttons: [Button]

    public init(title: String, sections: [SectionViewModel], buttons: [Button]) {
        self.title = title
        self.sections = sections
        self.buttons = buttons
    }
}
