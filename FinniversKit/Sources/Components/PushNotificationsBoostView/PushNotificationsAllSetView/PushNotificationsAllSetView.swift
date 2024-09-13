import SwiftUI
import Warp

struct PushNotificationsAllSetView: View {
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
    PushNotificationsAllSetView(PushNotificationsAllSetViewModel(icon: Image, title: <#T##String#>))
}
