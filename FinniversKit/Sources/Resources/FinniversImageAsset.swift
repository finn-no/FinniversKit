//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

// Generated by generate_image_assets_symbols as a "Run Script" Build Phase
// WARNING: This file is autogenerated, do not modify by hand

import UIKit

private class BundleHelper {
}

public extension UIImage {
    convenience init(named imageAsset: FinniversImageAsset) {
        self.init(named: imageAsset.rawValue, in: Bundle(for: BundleHelper.self), compatibleWith: nil)!
    }

    @objc class func assetNamed(_ assetName: String) -> UIImage {
        return UIImage(named: assetName, in: Bundle(for: BundleHelper.self), compatibleWith: nil)!
    }
}

//swiftlint:disable superfluous_disable_command
//swiftlint:disable type_body_length
public enum FinniversImageAsset: String {
    case adManagementShare
    case adManagementTrashcan
    case alphabeticalSortingAscending
    case arrowDown
    case arrowDownSmall
    case arrowRight
    case arrowUp
    case arrowUpSmall
    case attachment
    case avatar
    case balloon0
    case balloon00
    case balloon2
    case balloon22
    case bankID
    case betaPill
    case blockUser
    case boat
    case calendar
    case camera
    case candyCane
    case car
    case check
    case checkCircle
    case checkCircleFilledMini
    case checkmarkBig
    case christmasWishListBanner
    case classifieds
    case clock
    case close
    case confetti1
    case confetti2
    case creditcard
    case cross
    case distance
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
    case favoriteActiveSmall
    case favoriteAdd
    case favoriteDefault
    case favoriteDefaultSmall
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
    case heartEmpty
    case heartEmptyDashed
    case help
    case hide
    case home
    case iconRealestateApartments
    case iconRealestateBedrooms
    case iconRealestateOwner
    case iconRealestatePrice
    case important
    case info
    case jobs
    case klimaboletBanner
    case listView
    case magnifyingGlass
    case mapDirections
    case mapDrawarea
    case mapMyposition
    case mc
    case messages
    case minus
    case miscCross
    case miscDislike
    case miscDisliked
    case miscLike
    case miscLiked
    case miscMoney
    case mittanbud
    case more
    case moreImg
    case moteplassen
    case multipleContracts
    case navigation
    case noImage
    case notifications
    case notificationsBell
    case okonomi
    case ornamentCircleBlue
    case ornamentCircleRed
    case ornamentStar
    case pencilPaper
    case pin
    case playVideo
    case plus
    case plusMini
    case primingFavoritesComments
    case primingFavoritesSearch
    case primingFavoritesSharing
    case profile
    case rate
    case rated
    case ratingCat
    case ratingFaceAngry
    case ratingFaceDissatisfied
    case ratingFaceHappy
    case ratingFaceLove
    case ratingFaceNeutral
    case ratings
    case realestate
    case remove
    case republish
    case search
    case searchBig
    case send
    case settings
    case share
    case shopping
    case sliderThumb
    case sliderThumbActive
    case snowflake
    case sold
    case spark
    case speechbubbleSmiley
    case spidLogo
    case stakeholder
    case starOutline
    case statsEmpty
    case statsEnvelope
    case statsEye
    case statsHeart
    case success
    case trashcan
    case travel
    case uncheckCircle
    case vehicles
    case verified
    case view
    case viewMode
    case virtualViewing
    case webview
    case wrench
    case yourads

    public static var imageNames: [FinniversImageAsset] {
        return [
            .adManagementShare,
            .adManagementTrashcan,
            .alphabeticalSortingAscending,
            .arrowDown,
            .arrowDownSmall,
            .arrowRight,
            .arrowUp,
            .arrowUpSmall,
            .attachment,
            .avatar,
            .balloon0,
            .balloon00,
            .balloon2,
            .balloon22,
            .bankID,
            .betaPill,
            .blockUser,
            .boat,
            .calendar,
            .camera,
            .candyCane,
            .car,
            .check,
            .checkCircle,
            .checkCircleFilledMini,
            .checkmarkBig,
            .christmasWishListBanner,
            .classifieds,
            .clock,
            .close,
            .confetti1,
            .confetti2,
            .creditcard,
            .cross,
            .distance,
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
            .favoriteActiveSmall,
            .favoriteAdd,
            .favoriteDefault,
            .favoriteDefaultSmall,
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
            .heartEmpty,
            .heartEmptyDashed,
            .help,
            .hide,
            .home,
            .iconRealestateApartments,
            .iconRealestateBedrooms,
            .iconRealestateOwner,
            .iconRealestatePrice,
            .important,
            .info,
            .jobs,
            .klimaboletBanner,
            .listView,
            .magnifyingGlass,
            .mapDirections,
            .mapDrawarea,
            .mapMyposition,
            .mc,
            .messages,
            .minus,
            .miscCross,
            .miscDislike,
            .miscDisliked,
            .miscLike,
            .miscLiked,
            .miscMoney,
            .mittanbud,
            .more,
            .moreImg,
            .moteplassen,
            .multipleContracts,
            .navigation,
            .noImage,
            .notifications,
            .notificationsBell,
            .okonomi,
            .ornamentCircleBlue,
            .ornamentCircleRed,
            .ornamentStar,
            .pencilPaper,
            .pin,
            .playVideo,
            .plus,
            .plusMini,
            .primingFavoritesComments,
            .primingFavoritesSearch,
            .primingFavoritesSharing,
            .profile,
            .rate,
            .rated,
            .ratingCat,
            .ratingFaceAngry,
            .ratingFaceDissatisfied,
            .ratingFaceHappy,
            .ratingFaceLove,
            .ratingFaceNeutral,
            .ratings,
            .realestate,
            .remove,
            .republish,
            .search,
            .searchBig,
            .send,
            .settings,
            .share,
            .shopping,
            .sliderThumb,
            .sliderThumbActive,
            .snowflake,
            .sold,
            .spark,
            .speechbubbleSmiley,
            .spidLogo,
            .stakeholder,
            .starOutline,
            .statsEmpty,
            .statsEnvelope,
            .statsEye,
            .statsHeart,
            .success,
            .trashcan,
            .travel,
            .uncheckCircle,
            .vehicles,
            .verified,
            .view,
            .viewMode,
            .virtualViewing,
            .webview,
            .wrench,
            .yourads,
    ]
  }
}
