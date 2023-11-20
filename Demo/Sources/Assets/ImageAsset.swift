//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

// Generated by generate_image_assets_symbols as a "Run Script" Build Phase
// WARNING: This file is autogenerated, do not modify by hand

import UIKit

private class BundleHelper {
}

extension UIImage {
    convenience init(named imageAsset: ImageAsset) {
        #if SWIFT_PACKAGE
        let bundle = Bundle.module
        #else
        let bundle = Bundle(for: BundleHelper.self)
        #endif
        self.init(named: imageAsset.rawValue, in: bundle, compatibleWith: nil)! // swiftlint:disable:this force_unwrapping
    }

    @objc class func assetNamed(_ assetName: String) -> UIImage {
        #if SWIFT_PACKAGE
        let bundle = Bundle.module
        #else
        let bundle = Bundle(for: BundleHelper.self)
        #endif
        return UIImage(named: assetName, in: bundle, compatibleWith: nil)! // swiftlint:disable:this force_unwrapping
    }
}

//swiftlint:disable:next blanket_disable_command
//swiftlint:disable superfluous_disable_command
//swiftlint:disable:next blanket_disable_command
//swiftlint:disable type_body_length
enum ImageAsset: String {
    case adManagementTrashcan
    case adsenseDemo
    case airplane
    case animals
    case antiques
    case arrowCounterClockwise
    case autovex
    case avatar
    case bapShippable
    case betaImageSearch
    case blinkRocketMini
    case cabin
    case car
    case carFront
    case carIllustration
    case carPromo
    case carsCircleIllustration
    case checkCircle
    case checkCircleFilled
    case christmasPromotion
    case clothing
    case contract
    case creditCard
    case cross
    case displayTypeGrid
    case displayTypeList
    case dissatisfiedFace
    case easterEgg
    case economy
    case electronics
    case emptyMoon
    case emptyStateSaveSearch
    case eyeHide
    case favoriteActive
    case favorites
    case favouriteAdded
    case filledMoon
    case filter
    case finnLogo
    case finnLogoSimple
    case furniture
    case gift
    case heartEmpty
    case hjerterom
    case hobbies
    case hobbyIllustration
    case home
    case honk
    case iconRealestateApartments
    case iconRealestateBedrooms
    case iconRealestateOwner
    case iconRealestatePrice
    case jobs
    case magnifyingGlass
    case market
    case messages
    case mittanbud
    case more
    case motorcycle
    case nettbil
    case notifications
    case npCompare
    case npDrive
    case npHouseWeather
    case npPublicTransport
    case npRecommended
    case npSafeNeighborhood
    case npSchool
    case npStopwatch
    case npStore
    case npWalk
    case nyhetsbrevFraFinn
    case oikotie
    case parentskids
    case pencilPaper
    case pin
    case playVideo
    case plus
    case primingFavoritesComments
    case primingFavoritesSearch
    case primingFavoritesSharing
    case profile
    case rated
    case ratings
    case realestate
    case refurbishedelectronics
    case remove
    case removeFilterTag
    case remppatori
    case renovation
    case rentalcar
    case republish
    case sailboat
    case savedSearches
    case search
    case service
    case shop
    case sold
    case sports
    case stakeholder
    case torgetHelthjem
    case transactionJourneyCar
    case uncheckCircle
    case vehicles
    case vehiclesparts
    case view
    case virtualViewing
    case warranty
    case webview
    case wrench
    case yourads

    static var imageNames: [ImageAsset] {
        return [
            .adManagementTrashcan,
            .adsenseDemo,
            .airplane,
            .animals,
            .antiques,
            .arrowCounterClockwise,
            .autovex,
            .avatar,
            .bapShippable,
            .betaImageSearch,
            .blinkRocketMini,
            .cabin,
            .car,
            .carFront,
            .carIllustration,
            .carPromo,
            .carsCircleIllustration,
            .checkCircle,
            .checkCircleFilled,
            .christmasPromotion,
            .clothing,
            .contract,
            .creditCard,
            .cross,
            .displayTypeGrid,
            .displayTypeList,
            .dissatisfiedFace,
            .easterEgg,
            .economy,
            .electronics,
            .emptyMoon,
            .emptyStateSaveSearch,
            .eyeHide,
            .favoriteActive,
            .favorites,
            .favouriteAdded,
            .filledMoon,
            .filter,
            .finnLogo,
            .finnLogoSimple,
            .furniture,
            .gift,
            .heartEmpty,
            .hjerterom,
            .hobbies,
            .hobbyIllustration,
            .home,
            .honk,
            .iconRealestateApartments,
            .iconRealestateBedrooms,
            .iconRealestateOwner,
            .iconRealestatePrice,
            .jobs,
            .magnifyingGlass,
            .market,
            .messages,
            .mittanbud,
            .more,
            .motorcycle,
            .nettbil,
            .notifications,
            .npCompare,
            .npDrive,
            .npHouseWeather,
            .npPublicTransport,
            .npRecommended,
            .npSafeNeighborhood,
            .npSchool,
            .npStopwatch,
            .npStore,
            .npWalk,
            .nyhetsbrevFraFinn,
            .oikotie,
            .parentskids,
            .pencilPaper,
            .pin,
            .playVideo,
            .plus,
            .primingFavoritesComments,
            .primingFavoritesSearch,
            .primingFavoritesSharing,
            .profile,
            .rated,
            .ratings,
            .realestate,
            .refurbishedelectronics,
            .remove,
            .removeFilterTag,
            .remppatori,
            .renovation,
            .rentalcar,
            .republish,
            .sailboat,
            .savedSearches,
            .search,
            .service,
            .shop,
            .sold,
            .sports,
            .stakeholder,
            .torgetHelthjem,
            .transactionJourneyCar,
            .uncheckCircle,
            .vehicles,
            .vehiclesparts,
            .view,
            .virtualViewing,
            .warranty,
            .webview,
            .wrench,
            .yourads,
    ]
  }
}
