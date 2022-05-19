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
    case adManagementTrashcan
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
    case checkCircle
    case checkCircleFilled
    case checkCircleFilledMini
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
    case eyeHide
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
    case rate
    case rated
    case ratingCat
    case ratingFaceAngry
    case ratingFaceDissatisfied
    case ratingFaceHappy
    case ratingFaceLove
    case ratingFaceNeutral
    case ratings
    case remove
    case republish
    case search
    case searchBig
    case send
    case settings
    case share
    case sliderThumb
    case sliderThumbActive
    case speechbubbleSmiley
    case spidLogo
    case stakeholder
    case starOutline
    case statsEmpty
    case statsEnvelope
    case statsEye
    case statsHeart
    case success
    case uncheckCircle
    case view
    case viewMode
    case warning
    case webview

    static var imageNames: [ImageAsset] {
        return [
            .adManagementShare,
            .adManagementTrashcan,
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
            .checkCircle,
            .checkCircleFilled,
            .checkCircleFilledMini,
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
            .eyeHide,
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
            .rate,
            .rated,
            .ratingCat,
            .ratingFaceAngry,
            .ratingFaceDissatisfied,
            .ratingFaceHappy,
            .ratingFaceLove,
            .ratingFaceNeutral,
            .ratings,
            .remove,
            .republish,
            .search,
            .searchBig,
            .send,
            .settings,
            .share,
            .sliderThumb,
            .sliderThumbActive,
            .speechbubbleSmiley,
            .spidLogo,
            .stakeholder,
            .starOutline,
            .statsEmpty,
            .statsEnvelope,
            .statsEye,
            .statsHeart,
            .success,
            .uncheckCircle,
            .view,
            .viewMode,
            .warning,
            .webview,
    ]
  }
}
