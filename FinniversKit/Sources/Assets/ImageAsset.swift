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
    case arrowDown
    case arrowDownSmall
    case arrowRight
    case arrowUp
    case arrowUpSmall
    case attachment
    case attachmentMore
    case avatar
    case bankID
    case betaPill
    case calendar
    case camera
    case car
    case check
    case checkCircleFilled
    case checkCircleFilledMini
    case checkboxSelected
    case checkboxUnselected
    case checkmark
    case checkmarkBig
    case checkmarkBlue
    case christmasWishListBanner
    case close
    case confetti1
    case confetti2
    case consentTransparency
    case contract
    case creditcard
    case cross
    case document
    case download
    case earthHourClock
    case earthHourEarth
    case earthHourEyes
    case earthHourHeart
    case earthHourStars
    case easterEgg
    case edit
    case editBig
    case emptyPersonalNotifications
    case error
    case exclamationMarkTriangleMini
    case favoriteActive
    case favoriteAdd
    case favoriteDefault
    case favoritesComment
    case favoritesDelete
    case favoritesEdit
    case favoritesNote
    case favoritesPlus
    case favoritesShare
    case favoritesShareLink
    case favoritesSortAdStatus
    case favoritesSortDistance
    case favoritesSortLastAdded
    case favoritesXmasButton
    case favoritesXmasFolder
    case favouriteAddImg
    case favouriteAdded
    case favouriteAddedImg
    case favourites
    case finnLogo
    case finnLogoSimple
    case gallery
    case gift
    case gridView
    case handshake
    case heartEmptyDashed
    case help
    case hide
    case important
    case infoboxCritical
    case infoboxInfo
    case infoboxSuccess
    case infoboxWarning
    case klimabroletBanner
    case listView
    case magnifyingGlass
    case mapDirections
    case mapDrawarea
    case mapLocationPin
    case mapMyposition
    case messageUserRequired
    case minus
    case miscCross
    case miscDislike
    case miscDisliked
    case miscLike
    case miscLiked
    case miscMoney
    case more
    case moreImg
    case navigation
    case noImage
    case notifications
    case padlock
    case pencilPaper
    case pin
    case playVideo
    case plusMini
    case pusefinnCircle
    case radioButtonSelected
    case radioButtonUnselected
    case rate
    case ratingFaceAngry
    case ratingFaceDissatisfied
    case ratingFaceHappy
    case ratingFaceLove
    case ratingFaceNeutral
    case ratings
    case remove
    case search
    case searchBig
    case send
    case settings
    case share
    case sliderThumb
    case sliderThumbActive
    case speechbubbleSmiley
    case spidLogo
    case starOutline
    case success
    case trustStarOutline
    case trustVerified
    case trustVerifiedOutline
    case view
    case viewMode
    case webview

    static var imageNames: [ImageAsset] {
        return [
            .arrowDown,
            .arrowDownSmall,
            .arrowRight,
            .arrowUp,
            .arrowUpSmall,
            .attachment,
            .attachmentMore,
            .avatar,
            .bankID,
            .betaPill,
            .calendar,
            .camera,
            .car,
            .check,
            .checkCircleFilled,
            .checkCircleFilledMini,
            .checkboxSelected,
            .checkboxUnselected,
            .checkmark,
            .checkmarkBig,
            .checkmarkBlue,
            .christmasWishListBanner,
            .close,
            .confetti1,
            .confetti2,
            .consentTransparency,
            .contract,
            .creditcard,
            .cross,
            .document,
            .download,
            .earthHourClock,
            .earthHourEarth,
            .earthHourEyes,
            .earthHourHeart,
            .earthHourStars,
            .easterEgg,
            .edit,
            .editBig,
            .emptyPersonalNotifications,
            .error,
            .exclamationMarkTriangleMini,
            .favoriteActive,
            .favoriteAdd,
            .favoriteDefault,
            .favoritesComment,
            .favoritesDelete,
            .favoritesEdit,
            .favoritesNote,
            .favoritesPlus,
            .favoritesShare,
            .favoritesShareLink,
            .favoritesSortAdStatus,
            .favoritesSortDistance,
            .favoritesSortLastAdded,
            .favoritesXmasButton,
            .favoritesXmasFolder,
            .favouriteAddImg,
            .favouriteAdded,
            .favouriteAddedImg,
            .favourites,
            .finnLogo,
            .finnLogoSimple,
            .gallery,
            .gift,
            .gridView,
            .handshake,
            .heartEmptyDashed,
            .help,
            .hide,
            .important,
            .infoboxCritical,
            .infoboxInfo,
            .infoboxSuccess,
            .infoboxWarning,
            .klimabroletBanner,
            .listView,
            .magnifyingGlass,
            .mapDirections,
            .mapDrawarea,
            .mapLocationPin,
            .mapMyposition,
            .messageUserRequired,
            .minus,
            .miscCross,
            .miscDislike,
            .miscDisliked,
            .miscLike,
            .miscLiked,
            .miscMoney,
            .more,
            .moreImg,
            .navigation,
            .noImage,
            .notifications,
            .padlock,
            .pencilPaper,
            .pin,
            .playVideo,
            .plusMini,
            .pusefinnCircle,
            .radioButtonSelected,
            .radioButtonUnselected,
            .rate,
            .ratingFaceAngry,
            .ratingFaceDissatisfied,
            .ratingFaceHappy,
            .ratingFaceLove,
            .ratingFaceNeutral,
            .ratings,
            .remove,
            .search,
            .searchBig,
            .send,
            .settings,
            .share,
            .sliderThumb,
            .sliderThumbActive,
            .speechbubbleSmiley,
            .spidLogo,
            .starOutline,
            .success,
            .trustStarOutline,
            .trustVerified,
            .trustVerifiedOutline,
            .view,
            .viewMode,
            .webview,
    ]
  }
}
