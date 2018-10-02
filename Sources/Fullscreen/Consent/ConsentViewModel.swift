//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import Foundation

public struct ConsentViewModel {
    public let title: String?
    public var state: Bool
    public let text: String
    public let buttonTitle: String
    public let buttonStyle: Button.Style
    public let indexPath: IndexPath

    public init(title: String?, state: Bool, text: String, buttonTitle: String, buttonStyle: Button.Style, indexPath: IndexPath) {
        self.title = title
        self.state = state
        self.text = text
        self.buttonTitle = buttonTitle
        self.buttonStyle = buttonStyle
        self.indexPath = indexPath
    }
}
