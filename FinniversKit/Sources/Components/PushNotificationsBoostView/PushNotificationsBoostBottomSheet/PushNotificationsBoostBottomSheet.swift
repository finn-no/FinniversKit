import SwiftUI
import Warp

struct PushNotificationsBoostBottomSheet: View {
    let viewModel: PushNotificationsBoostBottomSheetViewModel

    public init(viewModel: PushNotificationsBoostBottomSheetViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Warp.Spacing.spacing200) {


        }
    }
}

#Preview {
    let section1 = PushNotificationsBoostBottomSheetViewModel.SectionViewModel(
        icon: Image(.avatar),
        title: "Instant Updates",
        description: "Receive alerts the moment a buyer shows interest in your items."
    )
    let section2 = PushNotificationsBoostBottomSheetViewModel.SectionViewModel(
        icon: Image(.avatar),
        title: "Quick Responses",
        description: "Respond faster to messages, increasing your chances of making a sale."
    )
    let section3 = PushNotificationsBoostBottomSheetViewModel.SectionViewModel(
        icon: Image(.avatar),
        title: "Stay ahead",
        description: "Be the first to know when there’s a new match for your listings or a price drop on items you’re following."
    )

    let allowButton = PushNotificationsBoostBottomSheetViewModel.Button(
        kind: .allow,
        title: "Allow Push Notifications"
    )
    let notNowButton = PushNotificationsBoostBottomSheetViewModel.Button(
        kind: .notNow,
        title: "Not now"
    )

    let viewModel = PushNotificationsBoostBottomSheetViewModel(
        title: "Never miss a beat!",
        sections: [section1, section2, section3],
        buttons: [allowButton, notNowButton]
    )

    return PushNotificationsBoostBottomSheet(viewModel: viewModel)
}
