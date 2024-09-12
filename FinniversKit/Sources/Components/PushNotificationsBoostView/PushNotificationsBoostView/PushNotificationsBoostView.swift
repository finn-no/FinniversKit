import SwiftUI
import Warp

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

            HStack(spacing: Warp.Spacing.spacing200) {
                Image(named: .alarmOff)
                    .padding(.leading)

                VStack(alignment: .leading, spacing: Warp.Spacing.spacing50) {
                    Text(model.title)
                        .font(.finnFont(.bodyStrong))
                    Text(model.description)
                        .finnFont(.caption)
                        .foregroundColor(.text)
                }

                Spacer()

            }

            Divider()
                .foregroundColor(.border)
        }
    }
}

#Preview {
    PushNotificationsBoostView(model: PushNotificationsBoostViewModel(
        title: "Boost your chances of a quick sale!",
        description: "Get real-time alerts when buyers message you or express interest in your items."
    ))
}
