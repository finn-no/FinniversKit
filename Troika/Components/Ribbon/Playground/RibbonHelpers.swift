//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation
import Troika

public enum RibbonDataModel: RibbonModel {

    case ordinary
    case success
    case warning
    case error
    case disabled
    case sponsored

    public var type: RibbonType {
        switch self {
        case .ordinary: return RibbonType.ordinary
        case .success: return RibbonType.success
        case .warning: return RibbonType.warning
        case .error: return RibbonType.error
        case .disabled: return RibbonType.disabled
        case .sponsored: return RibbonType.sponsored
        }
    }

    public var title: String {
        switch self {
        case .ordinary: return "Default"
        case .success: return "Success"
        case .warning: return "Warning"
        case .error: return "Error"
        case .disabled: return "Disabled"
        case .sponsored: return "Sponsored"
        }
    }

    public var accessibilityLabel: String {
        return "Merk: " + title
    }
}

public let headerLabel: Label = {
    let label = Label(style: .title1)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Status ribbon"
    return label
}()
