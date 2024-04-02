//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol MessageFormViewModel: AnyObject {
    var titleText: String { get }
    var sendButtonText: String { get }
    var editButtonText: String { get }
    var doneButtonText: String { get }
    var saveButtonText: String { get }
    var cancelButtonText: String { get }
    var deleteActionText: String { get }
    var transparencyText: String { get }
    var disclaimerText: String { get }

    var messageText: String { get }
    var messageHint: String { get }
    var telephoneText: String { get }
    var telephoneHint: String { get }

    var cancelFormAlertTitle: String { get }
    var cancelFormAlertMessage: String { get }
    var cancelFormAlertActionText: String { get }
    var cancelFormAlertCancelText: String { get }
}
