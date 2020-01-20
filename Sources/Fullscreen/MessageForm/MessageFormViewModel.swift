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

public struct MessageFormViewModel {
    public let showTemplateToolbar: Bool
    public let transparencyText: String
    public let messageTemplates: [MessageFormTemplate]

    public init(showTemplateToolbar: Bool, transparencyText: String, messageTemplates: [MessageFormTemplate]) {
        self.showTemplateToolbar = showTemplateToolbar
        self.transparencyText = transparencyText
        self.messageTemplates = messageTemplates
    }
}
