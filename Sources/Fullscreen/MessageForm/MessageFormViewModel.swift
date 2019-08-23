//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public struct MessageFormTemplate {
    public let text: String
    public let isUserDefined: Bool
    public let id: String?

    public init(text: String, isUserDefined: Bool, id: String? = nil) {
        self.text = text
        self.isUserDefined = isUserDefined
        self.id = id
    }
}

public protocol MessageFormViewModel: AnyObject {
    var showTemplateToolbar: Bool { get }
    var showCustomizeButton: Bool { get }
    var messageTemplateStore: MessageTemplateStoreProtocol? { get }

    var titleText: String { get }
    var sendButtonText: String { get }
    var editButtonText: String { get }
    var doneButtonText: String { get }
    var saveButtonText: String { get }
    var cancelButtonText: String { get }
    var deleteActionText: String { get }
    var transparencyText: String { get }
    var defaultMessageTemplates: [MessageFormTemplate] { get }

    var replaceAlertTitle: String { get }
    var replaceAlertMessage: String { get }
    var replaceAlertActionText: String { get }
    var replaceAlertCancelText: String { get }

    var cancelFormAlertTitle: String { get }
    var cancelFormAlertMessage: String { get }
    var cancelFormAlertActionText: String { get }
    var cancelFormAlertCancelText: String { get }

    var customTemplatesTitleText: String { get }
    var customTemplateEditText: String { get }
    var customTemplateNewText: String { get }
    var newCustomTemplatePromptText: String { get }
    var noCustomTemplatesText: String { get }
}
