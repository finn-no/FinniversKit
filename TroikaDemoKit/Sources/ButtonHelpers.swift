//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation
import Troika

public enum ButtonDataModel: ButtonPresentable {
    case normal // default
    case flat
    case destructive

    public var title: String {
        switch self {
        case .normal: return "Normal"
        case .flat: return "Søk"
        case .destructive: return "Slett"
        }
    }

    public var type: Button.ButtonType {
        switch self {
        case .normal: return .normal
        case .flat: return .flat
        case .destructive: return .destructive
        }
    }

    public var accessibilityLabel: String {
        return "Knapp: " + title
    }
}
