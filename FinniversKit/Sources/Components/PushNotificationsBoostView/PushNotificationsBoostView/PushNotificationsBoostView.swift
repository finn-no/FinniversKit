import SwiftUI
import Warp

public struct PushNotificationsBoostView: View {
    public static let pushNotificationBoostViewCellIdentifier = "pushNotificationBoostViewCellIdentifier"
    let viewModel: PushNotificationsBoostViewModel

    public init(viewModel: PushNotificationsBoostViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: Warp.Spacing.spacing200) {
            if !viewModel.isSeparatorsHidden {
                Divider()
                    .foregroundColor(.border)
            }

            HStack(spacing: Warp.Spacing.spacing200) {
                viewModel.icon
                    .padding(.leading)

                VStack(alignment: .leading, spacing: Warp.Spacing.spacing50) {
                    Text(viewModel.title)
                        .font(.finnFont(.bodyStrong))
                    if let description = viewModel.description {
                        Text(description)
                            .finnFont(.caption)
                            .foregroundColor(.text)
                    }
                }

                Spacer()

                if viewModel.isClosable {
                    SwiftUI.Button(action: {
                        viewModel.closeButtonAction?()
                    }, label: {
                        Image(named: .closeCross)
                            .renderingMode(.original)
                    })
                }

            }

            if !viewModel.isSeparatorsHidden {
                Divider()
                    .foregroundColor(.border)
            }
        }
    }
}

#Preview {
    PushNotificationsBoostView(viewModel: PushNotificationsBoostViewModel(
        icon: Image(named: .bellOff),
        title: "Boost your chances of a quick sale!",
        description: "Get real-time alerts when buyers message you or express interest in your items."
    ))
}

#Preview {
    PushNotificationsBoostView(viewModel: PushNotificationsBoostViewModel(
        icon: Image(named: .bell),
        title: "You’re all set!"
    ))
}
