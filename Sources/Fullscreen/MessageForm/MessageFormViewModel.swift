//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol MessageFormViewModel: AnyObject {
    var showTemplateToolbar: Bool { get }
    var showTemplateCustomizationButton: Bool { get }

    var titleText: String { get }
    var sendButtonText: String { get }
    var cancelButtonText: String { get }
    var transparencyText: String { get }
    var messageTemplates: [String] { get }

    var replaceAlertTitle: String { get }
    var replaceAlertMessage: String { get }
    var replaceAlertReplaceActionText: String { get }
    var replaceAlertCancelActionText: String { get }
}
