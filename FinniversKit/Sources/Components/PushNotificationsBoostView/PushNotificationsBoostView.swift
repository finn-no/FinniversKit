import SwiftUI
import Warp

public struct PushNotificationsBoostViewModel {
    let title: String
    let description: String

    public init(title: String, description: String) {
        self.title = title
        self.description = description
    }
}

public struct PushNotificationsBoostView: View {
    public static let pushNotificationBoostViewCellIdentifier = "pushNotificationBoostViewCellIdentifier"
    let model: PushNotificationsBoostViewModel

    public init(model: PushNotificationsBoostViewModel) {
        self.model = model
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Warp.Spacing.spacing200) {
            Divider()
                .foregroundColor(.border)
                .padding([.leading, .trailing], Warp.Spacing.spacing200)

            HStack {
                Image(named: .alarmOff)

                VStack(alignment: .leading, spacing: Warp.Spacing.spacing50) {
                    Text(model.title)
                        .font(.finnFont(.captionStrong))
                    Text(model.description)
                        .font(.finnFont(.body))
                }

                Image(named: .arrowRight)
            }

            Divider()
                .foregroundColor(.border)
                .padding([.leading, .trailing], Warp.Spacing.spacing200)
        }
    }
}

#Preview {
    PushNotificationsBoostView(model: PushNotificationsBoostViewModel(
        title: "Boost your chances of a quick sale!",
        description: "Get real-time alerts when buyers message you or express interest in your items."
    ))
}
