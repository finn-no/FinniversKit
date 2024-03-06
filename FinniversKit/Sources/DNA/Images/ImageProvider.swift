//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol ImageProvider {

    // General
    var placeholderAd: UIImage { get }
    var brandFavouriteAdd: UIImage { get }
    var brandFavouriteAdded: UIImage { get }
    var brandFavouriteAddImg: UIImage { get }
    var brandFavouriteAddedImg: UIImage { get }
    var brandCheckmark: UIImage { get }
    var brandSliderThumb: UIImage { get }
    var brandSliderThumbActive: UIImage { get }
    var brandLogoSimple: UIImage { get }
    var brandLogo: UIImage { get }
    var brandCheckboxSelected: UIImage { get }
    var brandCheckboxUnselected: UIImage { get }
    var brandRadioButtonSelected: UIImage { get }
    var brandRadioButtonUnselected: UIImage { get }

    // Messaging
    var brandMessageAttachMore: UIImage { get }

    // Trust
    var brandConsentTransparency: UIImage { get }
    var brandTrustStarOutline: UIImage { get }
    var brandTrustVerified: UIImage { get }
    var brandTrustVerifiedOutlined: UIImage { get }

    // Maps
    var brandMapDirections: UIImage { get }

}

// MARK: - Default FINN images

public struct DefaultImageProvider: ImageProvider {

    public static let shared = DefaultImageProvider()

    public var placeholderAd: UIImage {
        UIImage(named: .noImage)
    }

    public var brandFavouriteAdd: UIImage {
        UIImage(named: .favoriteAdd)
    }

    public var brandFavouriteAdded: UIImage {
        UIImage(named: .favouriteAdded)
    }

    public var brandFavouriteAddImg: UIImage {
        UIImage(named: .favouriteAddImg)
    }

    public var brandFavouriteAddedImg: UIImage {
        UIImage(named: .favouriteAddedImg)
    }

    public var brandCheckmark: UIImage {
        UIImage(named: .checkmarkBlue)
    }

    public var brandSliderThumb: UIImage {
        UIImage(named: .sliderThumb)
    }

    public var brandSliderThumbActive: UIImage {
        UIImage(named: .sliderThumbActive)
    }

    public var brandLogoSimple: UIImage {
        UIImage(named: .finnLogoSimple)
    }

    public var brandLogo: UIImage {
        UIImage(named: .finnLogo)
    }

    public var brandCheckboxSelected: UIImage {
        UIImage(named: .checkboxSelected)
    }

    public var brandCheckboxUnselected: UIImage {
        UIImage(named: .checkboxUnselected)
    }

    public var brandRadioButtonSelected: UIImage {
        UIImage(named: .radioButtonSelected)
    }

    public var brandRadioButtonUnselected: UIImage {
        UIImage(named: .radioButtonUnselected)
    }

    public var brandMessageAttachMore: UIImage {
        UIImage(named: .attachmentMore)
    }

    public var brandConsentTransparency: UIImage {
        UIImage(named: .consentTransparency)
    }

    public var brandTrustStarOutline: UIImage {
        UIImage(named: .trustStarOutline)
    }

    public var brandTrustVerified: UIImage {
        UIImage(named: .trustVerified)
    }

    public var brandTrustVerifiedOutlined: UIImage {
        UIImage(named: .trustVerifiedOutline)
    }

    public var brandMapDirections: UIImage {
        UIImage(named: .mapDirections)
    }
    
    public var toriLogo: UIImage {
        UIImage(named: .toriLogo)
    }
}
