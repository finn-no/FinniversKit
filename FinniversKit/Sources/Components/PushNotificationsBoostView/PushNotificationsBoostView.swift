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

                Image(named: .arrowRight)
                    .foregroundColor(.text)
                    .padding(.trailing)
            }

            Divider()
                .foregroundColor(.border)
        }
        .background(Color.backgroundInfoSubtle)
        .padding([.top, .bottom])
    }
}

#Preview {
    PushNotificationsBoostView(model: PushNotificationsBoostViewModel(
        title: "Boost your chances of a quick sale!",
        description: "Get real-time alerts when buyers message you or express interest in your items."
    ))
}
