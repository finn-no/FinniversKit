//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public protocol MessageFormViewModel: AnyObject {
    var titleText: String { get }
    var sendButtonText: String { get }
    var cancelButtonText: String { get }
    var transparencyText: String { get }
    var messageTemplates: [String] { get }
}
