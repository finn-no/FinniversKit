import SwiftUI
import Warp

public struct PushNotificationsBoostView: View {
    private let layoutMarginsGuideWidth: CGFloat = 685 // Designed to replicate layoutMarginsGuide for cellLayoutMarginsFollowReadableWidth UIKit's tableViews
    public static let pushNotificationBoostViewCellIdentifier = "pushNotificationBoostViewCellIdentifier"
    let viewModel: PushNotificationsBoostViewModel

    public init(viewModel: PushNotificationsBoostViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        if viewModel.layoutMarginsFollowReadableWidth {
            HStack {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    Spacer()
                }
                content
                    .frame(idealWidth: layoutMarginsGuideWidth, maxWidth: layoutMarginsGuideWidth)
                if UIDevice.current.userInterfaceIdiom == .pad {
                    Spacer()
                }
            }
        } else {
            content
        }
    }

    var content: some View {
        VStack(alignment: .leading, spacing: Warp.Spacing.spacing200) {
            Divider()
                .foregroundColor(.border)

            HStack {
                viewModel.icon
                    .padding(.leading, Warp.Spacing.spacing200)
                    .padding(.trailing, Warp.Spacing.spacing100)

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

                if viewModel.isClickable {
                    Image(named: .arrowRight)
                        .padding(.trailing, Warp.Spacing.spacing100)
                }

                if viewModel.isClosable {
                    SwiftUI.Button(action: {
                        viewModel.closeButtonAction?()
                    }, label: {
                        Image(named: .closeCross)
                            .renderingMode(.original)
                            .padding(.trailing, Warp.Spacing.spacing100)
                    })
                }

            }

            Divider()
                .foregroundColor(.border)
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
