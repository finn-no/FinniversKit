//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation

public protocol BannerTransparencyViewModel {
    var headerText: String { get }

    var adSettingsHeaderText: String { get }
    var adSettingsDetailText: String { get }
    var adSettingsButtonTitle: String { get }

    var readMoreHeaderText: String { get }
    var readMoreDetailText: String { get }
    var readMoreButtonTitle: String { get }
    
    var logoType: LogoType { get }
}

// MARK: - Section View Model

extension BannerTransparencyViewModel {
    var adSettingsModel: BannerTransparencySectionViewModel {
        return .init(headerText: adSettingsHeaderText, detailText: adSettingsDetailText, buttonTitle: adSettingsButtonTitle)
    }

    var readMoreModel: BannerTransparencySectionViewModel {
        return .init(headerText: readMoreHeaderText, detailText: readMoreDetailText, buttonTitle: readMoreButtonTitle)
    }
}

// MARK: - LogoType Enum

public enum LogoType {
    case finn
    case tori
}

struct BannerTransparencySectionViewModel {
    let headerText: String
    let detailText: String
    let buttonTitle: String
}
