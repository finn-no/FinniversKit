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
        self.init(named: imageAsset.rawValue, in: bundle, compatibleWith: nil)!
    }

    @objc class func assetNamed(_ assetName: String) -> UIImage {
        #if SWIFT_PACKAGE
        let bundle = Bundle.module
        #else
        let bundle = Bundle(for: BundleHelper.self)
        #endif
        return UIImage(named: assetName, in: bundle, compatibleWith: nil)!
    }
}

//swiftlint:disable superfluous_disable_command
//swiftlint:disable type_body_length
enum ImageAsset: String {
    case adManagementShare
    case arrowDown
    case arrowDownSmall
    case arrowRight
    case arrowUp
    case arrowUpSmall
    case attachment
    case avatar
    case bankID
    case betaPill
    case blockUser
    case calendar
    case camera
    case candyCane
    case car
    case carsCircleIllustration
    case carsIllustration
    case check
    case checkCircleFilled
    case checkCircleFilledMini
    case checkmark
    case checkmarkBig
    case christmasWishListBanner
    case clock
    case close
    case confetti1
    case confetti2
    case contract
    case creditcard
    case cross
    case distanceOutlined
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
    case giftRoundedRectRed
    case giftSquarePink
    case giftSquareYellow
    case giftTriangleGreen
    case gridView
    case handshake
    case heartEmptyDashed
    case help
    case hide
    case important
    case info
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
    case ornamentCircleBlue
    case ornamentCircleRed
    case ornamentStar
    case padlock
    case pencilPaper
    case pin
    case playVideo
    case plusMini
    case pusefinnCircle
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
    case statsEmpty
    case statsEnvelope
    case statsEye
    case statsHeart
    case success
    case view
    case viewMode
    case warning
    case webview

    static var imageNames: [ImageAsset] {
        return [
            .adManagementShare,
            .arrowDown,
            .arrowDownSmall,
            .arrowRight,
            .arrowUp,
            .arrowUpSmall,
            .attachment,
            .avatar,
            .bankID,
            .betaPill,
            .blockUser,
            .calendar,
            .camera,
            .candyCane,
            .car,
            .carsCircleIllustration,
            .carsIllustration,
            .check,
            .checkCircleFilled,
            .checkCircleFilledMini,
            .checkmark,
            .checkmarkBig,
            .christmasWishListBanner,
            .clock,
            .close,
            .confetti1,
            .confetti2,
            .contract,
            .creditcard,
            .cross,
            .distanceOutlined,
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
            .giftRoundedRectRed,
            .giftSquarePink,
            .giftSquareYellow,
            .giftTriangleGreen,
            .gridView,
            .handshake,
            .heartEmptyDashed,
            .help,
            .hide,
            .important,
            .info,
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
            .ornamentCircleBlue,
            .ornamentCircleRed,
            .ornamentStar,
            .padlock,
            .pencilPaper,
            .pin,
            .playVideo,
            .plusMini,
            .pusefinnCircle,
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
            .statsEmpty,
            .statsEnvelope,
            .statsEye,
            .statsHeart,
            .success,
            .view,
            .viewMode,
            .warning,
            .webview,
    ]
  }
}
