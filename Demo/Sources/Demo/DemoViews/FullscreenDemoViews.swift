//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//
import FinniversKit
import DemoKit

extension VerificationActionSheet: Demoable {
    public var overridesModalPresentationStyle: Bool { true }
}

extension MessageUserRequiredSheet: Demoable {
    public var overridesModalPresentationStyle: Bool { true }
}

enum FullscreenDemoViews: String, CaseIterable, DemoGroup, DemoGroupItem {
    case emptyView
    case reportAdView
    case buyerPickerView
    case registerView
    case loginEntryView
    case loadingView
    case soldView
    case confirmationView
    case fullscreenGallery
    case contactFormView
    case addressMapView
    case favoriteAdsList
    case verificationActionSheet
    case settingDetails
    case favoriteAdActionView
    case favoriteAdCommentInputView
    case favoriteFolderActionView
    case favoriteSold
    case betaFeatureView
    case resultView
    case confettiView
    case messageUserRequiredSheet

    static var groupTitle: String { "Fullscreen" }
    static var numberOfDemos: Int { allCases.count }

    static func demoGroupItem(for index: Int) -> any DemoGroupItem {
        allCases[index]
    }

    static func demoable(for index: Int) -> any Demoable {
        Self.allCases[index].demoable
    }

    var demoable: any Demoable {
        switch self {
        case .emptyView:
            return EmptyViewDemoView()
        case .reportAdView:
            return AdReporterDemoView()
        case .buyerPickerView:
            return BuyerPickerDemoView()
        case .registerView:
            return RegisterViewDemoView()
        case .loginEntryView:
            return LoginEntryViewDemoViewController()
        case .loadingView:
            return LoadingViewDemoView()
        case .soldView:
            return SoldViewDemoView()
        case .confirmationView:
            return ConfirmationViewDemoView()
        case .fullscreenGallery:
            return FullscreenGalleryDemoViewController()
        case .contactFormView:
            return ContactFormDemoView()
        case .addressMapView:
            return AddressMapDemoView()
        case .favoriteAdsList:
            return FavoriteAdsListDemoView()
        case .verificationActionSheet:
            let bottomSheet = VerificationActionSheet(viewModel: VerificationViewDefaultData())
            bottomSheet.actionDelegate = VerificationActionSheetDemoDelegate.shared
            return bottomSheet
        case .settingDetails:
            return SettingDetailsDemoViewController()
        case .favoriteAdActionView:
            return FavoriteAdActionDemoView()
        case .favoriteAdCommentInputView:
            return FavoriteAdCommentInputDemoView()
        case .favoriteFolderActionView:
            return FavoriteFolderActionDemoView()
        case .favoriteSold:
            return FavoriteSoldDemoView()
        case .betaFeatureView:
            return BetaFeatureDemoView()
        case .resultView:
            return ResultDemoView()
        case .confettiView:
            return ConfettiDemoView()
        case .messageUserRequiredSheet:
            let sheet = MessageUserRequiredSheet()
            sheet.configure(MessageUserRequiredData.labelText, buttonText: MessageUserRequiredData.buttonText)
            return sheet
        }
    }
}
