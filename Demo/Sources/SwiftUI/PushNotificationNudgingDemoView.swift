import DemoKit
import FinniversKit
import Foundation
import SwiftUI

struct PushNotificationNudgingDemoView_Previews: PreviewProvider, Demoable {
    static var previews: some View {
        VStack {
            PushNotificationNudgingView(viewModel: PushNotificationNudgingViewModel(
                icon: Image(uiImage: UIImage(named: .bellOff)),
                title: "Boost your chances of a quick sale!",
                description: "Get real-time alerts when buyers message you or express interest in your items.",
                state: .initialPrompt
            ))

            PushNotificationNudgingView(viewModel: PushNotificationNudgingViewModel(
                icon: Image(uiImage: UIImage(named: .bellOff)),
                title: "You won’t get notifications for now",
                description: "If you change your mind, you can edit your notification settings anytime.",
                state: .turnedOff
            ))

            PushNotificationNudgingView(viewModel: PushNotificationNudgingViewModel(
                icon: Image(uiImage: UIImage(named: .bell)),
                title: "You’re all set!",
                state: .allSet
            ))
        }
    }
}
