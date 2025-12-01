# FinniversKit Swift 6 Migration Plan

## Overview

FinniversKit is a core UI framework dependency that requires Swift 6 concurrency updates. This document outlines all types that need fixes, organized by priority and PR scope.

---

## PR 1: Global State (`Config.swift`) - HIGH PRIORITY

**File:** `FinniversKit/Sources/Config.swift`

### Current Code
```swift
public struct Config {
    public static var bundle: Bundle { Bundle.finniversKit }
    public static var imageProvider: ImageProvider = DefaultImageProvider()
    public static var isDynamicTypeEnabled: Bool = true
    // ...
}
```

### Required Changes
```swift
@MainActor
public struct Config {
    public static var bundle: Bundle { Bundle.finniversKit }
    public static var imageProvider: ImageProvider = DefaultImageProvider()
    public static var isDynamicTypeEnabled: Bool = true
    // ...
}
```

**Impact:** This single change will fix warnings in any code accessing `Config.isDynamicTypeEnabled` or `Config.imageProvider`.

---

## PR 2: Core Delegate Protocols - HIGH PRIORITY

These delegate protocols are used for UI callbacks and should be `@MainActor` isolated.

### Files to Update

| File | Protocol | Priority |
|------|----------|----------|
| `Components/FrontPageTransactionView/FrontPageTransactionViewModel.swift` | `FrontPageTransactionViewModelDelegate` | High |
| `Recycling/GridViews/AdRecommendations/Cell/AdRecommendationCell.swift` | `AdRecommendationCellDelegate` | High |
| `Components/FrontPageSavedSearchesView/FrontPageSavedSearchesView.swift` | `FrontPageSavedSearchesViewDelegate` | High |
| `Components/RemoteImageView/RemoteImageView.swift` | `RemoteImageViewDelegate` | High |
| `Components/RemoteImageView/RemoteImageView.swift` | `RemoteImageViewDataSource` | High |

### Example Fix
```swift
// Before
public protocol AdRecommendationCellDelegate: AnyObject {
    func adRecommendationCell(_ cell: AdRecommendationCell, didTapFavoriteButton button: UIButton)
}

// After
@MainActor
public protocol AdRecommendationCellDelegate: AnyObject {
    func adRecommendationCell(_ cell: AdRecommendationCell, didTapFavoriteButton button: UIButton)
}
```

---

## PR 3: ViewModels - HIGH PRIORITY

### FrontPageTransactionViewModel

**File:** `Components/FrontPageTransactionView/FrontPageTransactionViewModel.swift`

```swift
// Before
public final class FrontPageTransactionViewModel: Identifiable, ObservableObject {
    public weak var delegate: FrontPageTransactionViewModelDelegate?
    public var imageLoader: ImageLoader?
    // ...
}

// After
@MainActor
public final class FrontPageTransactionViewModel: Identifiable, ObservableObject {
    public weak var delegate: FrontPageTransactionViewModelDelegate?
    public var imageLoader: ImageLoader?
    // ...
}
```

### FrontPageSavedSearchesViewModel

**File:** `Components/FrontPageSavedSearchesView/FrontPageSavedSearchesViewModel.swift`

Add `@MainActor` to the class.

---

## PR 4: Data Models - Sendable Conformance - MEDIUM PRIORITY

These simple data structs should conform to `Sendable`:

| File | Type | Notes |
|------|------|-------|
| `Components/FrontPageSavedSearchesView/FrontPageSavedSearchesViewModel.swift` | `FrontPageSavedSearchViewModel` | Simple struct |
| `Recycling/GridViews/AdRecommendations/` | `StandardAdRecommendationViewModel` | Verify all properties are Sendable |
| `Recycling/GridViews/AdRecommendations/` | `JobAdRecommendationViewModel` | Verify all properties are Sendable |

### Example Fix
```swift
// Before
public struct FrontPageSavedSearchViewModel {
    public let id: String
    public let title: String
    // ...
}

// After
public struct FrontPageSavedSearchViewModel: Sendable {
    public let id: String
    public let title: String
    // ...
}
```

---

## PR 5: Additional Delegate Protocols - MEDIUM PRIORITY

All remaining public delegate protocols should be marked `@MainActor`:

### Fullscreen Components
- `SoldViewDelegate`
- `EmptyViewDelegate`
- `LoginEntryViewDelegate`
- `RegisterViewDelegate`
- `PopupViewDelegate`
- `ContactFormViewDelegate`
- `AdReporterDelegate`
- `ResultViewDelegate`
- `FavoriteAdActionViewDelegate`
- `FavoriteFolderActionViewDelegate`
- `FavoriteAdCommentInputViewDelegate`
- `FavoriteSoldViewDelegate`
- `BetaFeatureViewDelegate`
- `SettingDetailsViewDelegate`
- `VerificationActionSheetDelegate`
- `AddressMapViewDelegate`
- `MessageUserRequiredViewDelegate`
- `MessageUserRequiredSheetDelegate`
- `FullscreenGalleryViewControllerDelegate`
- `FullscreenGalleryTransitionDestinationDelegate`
- `FullscreenGalleryTransitionPresenterDelegate`

### List Views
- `FavoritesListViewDelegate`
- `FavoriteAdsListViewDelegate`
- `FavoriteFoldersListViewDelegate`
- `SavedSearchesListViewDelegate`
- `NotificationsListViewDelegate`
- `BasicTableViewDelegate`
- `SettingsViewDelegate`

### Grid Views
- `AdRecommendationsGridViewDelegate`
- `NeighborhoodProfileViewDelegate`
- `OverflowCollectionViewDelegate`

### Components
- `BroadcastDelegate`
- `FavoriteButtonViewDelegate`
- `FavoriteAdTableViewCellDelegate`
- `SelectionViewDelegate`
- `SelectionListViewDelegate`
- `TextFieldDelegate`
- `TextViewDelegate`
- `SearchViewDelegate`
- `SwitchViewDelegate`
- `StepSliderDelegate`
- `LoanCalculatorDelegate`
- `HappinessRatingViewDelegate`
- `InfoboxViewDelegate`
- `DisclaimerViewDelegate`
- `NavigationLinkViewDelegate`
- `CollapsibleContentViewDelegate`
- `QuestionnaireViewDelegate`
- `PromotionViewDelegate`
- `PrimingViewDelegate`
- `LoadingRetryViewDelegate`
- `FooterButtonViewDelegate`
- `LinkButtonListViewDelegate`
- `NumberedListViewDelegate`
- `ScrollableTabViewDelegate`
- `ViewingsListViewDelegate`
- `ViewingsRedesignViewDelegate`
- `AddressCardViewDelegate`
- `AddressComponentViewDelegate`
- `MapAddressButtonDelegate`
- `ContractActionViewDelegate`
- `ReviewButtonViewDelegate`
- `ReviewButtonControlDelegate`
- `JobApplyBoxViewDelegate`
- `SendInviteViewDelegate`
- `SafetyElementsViewDelegate`
- `VerificationViewDelegate`
- `FeedbackViewDelegate`
- `BannerTransparencyViewDelegate`
- `BottomSheetDelegate`
- `BottomSheetDragDelegate`
- `HorizontalSlideTransitionDelegate`
- `NativeAdvertViewDelegate`
- `NativeAdvertImageDelegate`
- `SelectorTitleViewDelegate`
- `HyperlinkTextViewViewModelDelegate`
- `RadioButtonDelegate`
- `CheckboxDelegate`
- `ConfirmationViewDelegate`
- `BuyerPickerViewDelegate`
- `DynamicStackViewDelegate`
- `RefreshControlDelegate`

---

## PR 6: Completion Handlers - LOW PRIORITY

Add `@Sendable` to completion handler closures where appropriate:

### RemoteImageViewDataSource
```swift
// Before
public protocol RemoteImageViewDataSource: AnyObject {
    func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
}

// After
@MainActor
public protocol RemoteImageViewDataSource: AnyObject {
    func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping @Sendable ((UIImage?) -> Void))
}
```

---

## PR 7: ImageProvider Protocol - MEDIUM PRIORITY

**File:** `FinniversKit/Sources/Config.swift` or related

```swift
// Ensure ImageProvider is Sendable or @MainActor
@MainActor
public protocol ImageProvider {
    // ...
}
```

---

## Migration Order

1. **PR 1: Config.swift** - Unblocks most static property access warnings
2. **PR 2: Core Delegates** - Fixes FrontPage-related delegate warnings
3. **PR 3: ViewModels** - Fixes FrontPageTransactionViewModel issues
4. **PR 4: Data Models** - Add Sendable to simple structs
5. **PR 5: Additional Delegates** - Complete delegate migration
6. **PR 6: Completion Handlers** - Final cleanup
7. **PR 7: ImageProvider** - Ensure protocol is properly isolated

---

## Testing Strategy

After each PR:
1. Build FinniversKit with strict concurrency enabled
2. Build app-modules to verify warnings are resolved
3. Run UI tests to ensure no runtime issues
4. Verify DemoApp still works correctly

---

## Temporary Workarounds for app-modules

While FinniversKit migration is in progress, use these workarounds:

```swift
// At the top of files that use FinniversKit types
@preconcurrency import FinniversKit

// For protocol conformances
extension MyClass: @MainActor SomeFinniversKitDelegate {
    // ...
}
```

---

## Notes

- FinniversKit is primarily a UI framework, so `@MainActor` is appropriate for most types
- All delegate protocols are UI callbacks and should be `@MainActor`
- Simple value types (structs with only value properties) should be `Sendable`
- Classes with mutable state should be `@MainActor` isolated
- The `Config` struct with static mutable properties is the highest priority fix
