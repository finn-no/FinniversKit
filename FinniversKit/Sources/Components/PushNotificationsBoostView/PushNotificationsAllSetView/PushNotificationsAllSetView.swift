import SwiftUI
import Warp

public struct PushNotificationsAllSetView: View {
    public static let pushNotificationAllSetViewCellIdentifier = "pushNotificationAllSetViewCellIdentifier"
    let model: PushNotificationsAllSetViewModel

    public init(model: PushNotificationsAllSetViewModel) {
        self.model = model
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Warp.Spacing.spacing200) {
            Divider()
                .foregroundColor(.border)

            HStack(spacing: Warp.Spacing.spacing200) {
                Image(named: .bell)
                    .padding(.leading)

                Text(model.title)
                    .font(.finnFont(.bodyStrong))

                Spacer()

            }

            Divider()
                .foregroundColor(.border)
        }
    }
}

#Preview {
    PushNotificationsAllSetView(model: PushNotificationsAllSetViewModel(
        icon: Image(named: .bell),
        title: "You’re all set!"
    ))
}
