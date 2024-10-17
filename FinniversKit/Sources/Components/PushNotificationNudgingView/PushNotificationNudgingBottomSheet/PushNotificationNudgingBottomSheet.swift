import SwiftUI
import Warp

public struct PushNotificationNudgingBottomSheet: View {
    let viewModel: PushNotificationNudgingBottomSheetViewModel

    public init(viewModel: PushNotificationNudgingBottomSheetViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(alignment: .center, spacing: Warp.Spacing.spacing200) {
            Text(viewModel.title)
                .finnFont(.title3)
                 .padding(.top)

            ForEach(viewModel.sections, id: \.self) {
                sectionView($0)
                    .padding([.leading, .trailing])
            }.padding(.top)

            Spacer()

            VStack {
                ForEach(viewModel.buttons, id: \.self) {
                    buttonView($0)
                        .padding([.leading, .trailing])
                }
            }.padding([.top, .bottom])
        }
    }
}

private extension PushNotificationNudgingBottomSheet {
    private func sectionView(_ section: PushNotificationNudgingBottomSheetViewModel.Section) -> some View {
        HStack(alignment: .center, spacing: Warp.Spacing.spacing200) {
            section.icon
                .padding(.leading)

            VStack(alignment: .leading, spacing: Warp.Spacing.spacing50) {
                if let title = section.title {
                    Text(title)
                        .finnFont(.captionStrong)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Text(section.description)
                    .finnFont(.caption)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
    }

    private func buttonView(_ button: PushNotificationNudgingBottomSheetViewModel.Button) -> some View {
        switch button.kind {
        case .allow:
            return Warp.Button.create(
                for: .primary,
                title: button.title,
                action: {
                    button.action?()
                },
                fullWidth: true
            )
        case .notNow:
            return Warp.Button.create(
                for: .secondary,
                title: button.title,
                action: {
                    button.action?()
                },
                fullWidth: true
            )
        }
    }
}

#Preview {
    let section1 = PushNotificationNudgingBottomSheetViewModel.Section(
        icon: Image(named: .bell),
        description: "Receive alerts the moment a buyer shows interest in your items."
    )
    let section2 = PushNotificationNudgingBottomSheetViewModel.Section(
        icon: Image(named: .bell),
        description: "Respond faster to messages, increasing your chances of making a sale."
    )
    let section3 = PushNotificationNudgingBottomSheetViewModel.Section(
        icon: Image(named: .bell),
        description: "Be the first to know when there’s a new match for your listings or a price drop on items you’re following."
    )

    let allowButton = PushNotificationNudgingBottomSheetViewModel.Button(
        kind: .allow,
        title: "Allow Push Notifications"
    )
    let notNowButton = PushNotificationNudgingBottomSheetViewModel.Button(
        kind: .notNow,
        title: "Not now"
    )

    let viewModel = PushNotificationNudgingBottomSheetViewModel(
        title: "Never miss a beat!",
        sections: [section1, section2, section3],
        buttons: [allowButton, notNowButton]
    )

    return PushNotificationNudgingBottomSheet(viewModel: viewModel)
}
