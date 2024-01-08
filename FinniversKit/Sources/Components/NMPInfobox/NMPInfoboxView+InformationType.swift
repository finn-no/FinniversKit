//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI

public extension NMPInfoboxView {
    /**
     Describes which type of information to present.

     You can use the default values as defined in Warp or you can create a `.custom` information type and thereby add your own:
        - backgroundColor
        - optional borderColor
        - optional sidebarColor
        - optional iconImage
     */
    enum InformationType {
        case critical
        case information
        case success
        case warning
        case custom(
            backgroundColor: Color,
            borderColor: Color?,
            sidebarColor: Color?,
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

        var sideboxColor: Color {
            switch self {
            case .critical:
                Color.sideboxCritical
            case .custom(_, _, let sideboxColor, _):
                sideboxColor ?? .clear
            case .information:
                Color.sideboxInfo
            case .success:
                Color.sideboxSuccess
            case .warning:
                Color.sideboxAlert
            }
        }

        var borderColor: Color {
            switch self {
            case .critical:
                Color.borderCritical
            case .custom(_, let borderColor, _, _):
                borderColor ?? .clear
            case .information:
                Color.borderInfo
            case .success:
                Color.borderSuccess
            case .warning:
                Color.borderAlert
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
