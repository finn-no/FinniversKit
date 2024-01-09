//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI

public extension NMPInfoboxView {
    /**
     Describes which type of information to present.

     You can use the default values as defined in Warp or you can create a `.custom` information type and thereby add your own:
        - backgroundColor
        - optional subtleBorderColor
        - optional borderColor
        - optional iconImage

    Where
    - `subtleBorderColor` is the color used for the border around your infobox
     - `borderColor` is the color used for the left 4px wide border
     */
    enum InformationType {
        case critical
        case information
        case success
        case warning
        case custom(
            backgroundColor: Color,
            subtleBorderColor: Color?,
            borderColor: Color?,
            iconImage: Image?
        )

        var backgroundColor: Color {
            switch self {
            case .critical:
                Color.bgInformationCritical
            case .custom(let backgroundColor, _, _, _):
                backgroundColor
            case .information:
                Color.bgInformationInfo
            case .success:
                Color.bgInformationSuccess
            case .warning:
                Color.bgInformationAlert
            }
        }

        var borderColor: Color {
            switch self {
            case .critical:
                Color.borderCritical
            case .custom(_, _, let borderColor, _):
                borderColor ?? .clear
            case .information:
                Color.borderInfo
            case .success:
                Color.borderSuccess
            case .warning:
                Color.borderWarning
            }
        }

        var subtleBorderColor: Color {
            switch self {
            case .critical:
                Color.borderCriticalSubtle
            case .custom(_, let subtleBorderColor, _, _):
                subtleBorderColor ?? .clear
            case .information:
                Color.borderInfoSubtle
            case .success:
                Color.borderSuccessSubtle
            case .warning:
                Color.borderWarningSubtle
            }
        }

        var icon: Image? {
            switch self {
            case .critical:
                Image(named: .infoboxCritical)
            case .information:
                Image(named: .infoboxInfo)
            case .success:
                Image(named: .infoboxSuccess)
            case .warning:
                Image(named: .infoboxWarning)
            case .custom(_, _, _, let iconImage):
                iconImage
            }
        }
    }
}
