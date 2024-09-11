import SwiftUI
import Warp

struct PushNotificationsBoostView: View {

    var body: some View {
        VStack(alignment: .leading, spacing: Warp.Spacing.spacing200) {
            Divider()
                .foregroundColor(.border)
                .padding([.leading, .trailing], Warp.Spacing.spacing200)

            HStack {
//                Image(.)
            }

            Divider()
                .foregroundColor(.border)
                .padding([.leading, .trailing], Warp.Spacing.spacing200)
        }
    }
}

#Preview {
    PushNotificationsBoostView()
}
