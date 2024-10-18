import DemoKit
import FinniversKit
import Foundation
import SwiftUI

struct PushNotificationNudgingBottomSheetDemoView_Previews: PreviewProvider, Demoable {
    static var previews: some View {
        let section1 = PushNotificationNudgingBottomSheetViewModel.Section(
            icon: Image(uiImage: UIImage(named: .bottomSheetBell)),
            description: "Get real-time alerts when somebody wants to buy your item."
        )
        let section2 = PushNotificationNudgingBottomSheetViewModel.Section(
            icon: Image(uiImage: UIImage(named: .bottomSheetFeedback)),
            description: "Reply faster to messages and increase your chances to a quick sale."
        )
        let section3 = PushNotificationNudgingBottomSheetViewModel.Section(
            icon: Image(uiImage: UIImage(named: .bottomSheetSearchFavorites)),
            description: "Hear instantly of a new match in your saved search or a price drop on a favourite."
        )

        let allowButton = PushNotificationNudgingBottomSheetViewModel.Button(
            kind: .allow,
            title: "Allow Push Notifications"
        )
        let notNowButton = PushNotificationNudgingBottomSheetViewModel.Button(
            kind: .notNow,
            title: "Not now"
        )

        let viewModel = PushNotificationNudgingBottomSheetViewModel(
            title: "Don’t miss out on important stuff",
            sections: [section1, section2, section3],
            buttons: [allowButton, notNowButton]
        )

        return PushNotificationNudgingBottomSheet(viewModel: viewModel)
    }
}
