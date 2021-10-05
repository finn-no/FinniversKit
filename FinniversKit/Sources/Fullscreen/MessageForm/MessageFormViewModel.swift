//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public struct MessageFormTemplate {
    public let text: String
    public let id: String?

    public init(text: String, id: String? = nil) {
        self.text = text
        self.id = id
    }
}

public protocol MessageFormViewModel: AnyObject {
    var showTemplateToolbar: Bool { get }

    var titleText: String { get }
    var sendButtonText: String { get }
    var editButtonText: String { get }
    var doneButtonText: String { get }
    var saveButtonText: String { get }
    var cancelButtonText: String { get }
    var deleteActionText: String { get }
    var transparencyText: String { get }
    var disclaimerText: String { get }
    var messageTemplates: [MessageFormTemplate] { get }

    var messageText: String { get }
    var messageHint: String { get }
    var telephoneText: String { get }
    var telephoneHint: String { get }

    var replaceAlertTitle: String { get }
    var replaceAlertMessage: String { get }
    var replaceAlertActionText: String { get }
    var replaceAlertCancelText: String { get }

    var cancelFormAlertTitle: String { get }
    var cancelFormAlertMessage: String { get }
    var cancelFormAlertActionText: String { get }
    var cancelFormAlertCancelText: String { get }
}
