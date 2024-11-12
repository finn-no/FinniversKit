import SwiftUI
import Warp

public struct PushNotificationNudgingView: View {
    private let layoutMarginsGuideWidth: CGFloat = 685 // Designed to replicate layoutMarginsGuide for cellLayoutMarginsFollowReadableWidth UIKit's tableViews
    public static let pushNotificationNudgingViewCellIdentifier = "pushNotificationNudgingViewCellIdentifier"
    let viewModel: PushNotificationNudgingViewModel

    public init(viewModel: PushNotificationNudgingViewModel) {
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
                        .font(from: .bodyStrong)
                        .accessibilityLabel(viewModel.title.withoutEmoji())
                    if let description = viewModel.description {
                        Text(description)
                            .font(from: .caption)
                            .foregroundColor(.text)
                            .accessibilityLabel(description.withoutEmoji())
                    }
                    if let linkDescription = viewModel.linkDescription {
                        Text(linkDescription)
                            .font(from: .caption)
                            .foregroundColor(.text)
                            .multilineTextAlignment(.leading)
                            .onTapGesture {
                                viewModel.linkAction?()
                            }
                    }
                }

                Spacer()

                if viewModel.state == .initialPrompt {
                    Image(named: .arrowRight)
                        .padding(.trailing, Warp.Spacing.spacing200)
                }

                if viewModel.state == .turnedOff {
                    SwiftUI.Button(action: {
                        viewModel.closeButtonAction?()
                    }, label: {
                        Image(named: .closeCross)
                            .renderingMode(.original)
                            .padding(.trailing, Warp.Spacing.spacing200)
                    })
                }

            }

            Divider()
                .foregroundColor(.border)
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    PushNotificationNudgingView(viewModel: PushNotificationNudgingViewModel(
        icon: Image(named: .bellOff),
        title: "Boost your chances of a quick sale!",
        description: "Get real-time alerts when buyers message you or express interest in your items.",
        state: .initialPrompt
    ))
}

#Preview {
    PushNotificationNudgingView(viewModel: PushNotificationNudgingViewModel(
        icon: Image(named: .bell),
        title: "You’re all set!",
        state: .allSet
    ))
}
