//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI
import Warp

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
                Color.backgroundNegativeSubtle
            case .custom(let backgroundColor, _, _, _):
                backgroundColor
            case .information:
                Color.backgroundInfoSubtle
            case .success:
                Color.backgroundPositiveSubtle
            case .warning:
                Color.backgroundWarningSubtle
            }
        }

        var borderColor: Color {
            switch self {
            case .critical:
                Warp.Token.borderNegative
            case .custom(_, _, let borderColor, _):
                borderColor ?? .clear
            case .information:
                Warp.Token.borderInfo
            case .success:
                Warp.Token.borderPositive
            case .warning:
                Warp.Token.borderWarning
            }
        }

        var subtleBorderColor: Color {
            switch self {
            case .critical:
                Warp.Token.borderNegativeSubtle
            case .custom(_, let subtleBorderColor, _, _):
                subtleBorderColor ?? .clear
            case .information:
                Warp.Token.borderInfoSubtle
            case .success:
                Warp.Token.borderPositiveSubtle
            case .warning:
                Warp.Token.borderWarningSubtle
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
