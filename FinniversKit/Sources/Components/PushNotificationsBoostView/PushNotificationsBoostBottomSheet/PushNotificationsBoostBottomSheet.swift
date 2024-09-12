import SwiftUI
import Warp

public struct PushNotificationsBoostBottomSheet: View {
    let viewModel: PushNotificationsBoostBottomSheetViewModel

    public init(viewModel: PushNotificationsBoostBottomSheetViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(alignment: .center, spacing: Warp.Spacing.spacing300) {
            Text(viewModel.title)
                .font(.finnFont(.title3Strong))

            ForEach(viewModel.sections, id: \.self) {
                sectionView($0)
            }

            ForEach(viewModel.buttons, id: \.self) {
                buttonView($0)
            }
        }
    }
}

private extension PushNotificationsBoostBottomSheet {
    private func sectionView(_ section: PushNotificationsBoostBottomSheetViewModel.Section) -> some View {
        HStack(spacing: Warp.Spacing.spacing200) {
            section.icon
                .padding(.leading)

            VStack(alignment: .leading, spacing: Warp.Spacing.spacing50) {
                Text(section.title)
                    .font(.finnFont(.bodyStrong))
                Text(section.description)
                    .finnFont(.caption)
            }
        }
    }

    private func buttonView(_ button: PushNotificationsBoostBottomSheetViewModel.Button) -> some View {
        switch button.kind {
        case .allow:
            return Warp.Button.create(for: .primary, title: button.title, action: {
                button.handle(button.kind)
            }, fullWidth: true)
        case .notNow:
            return Warp.Button.create(for: .secondary, title: button.title, action: {
                button.handle(button.kind)
            }, fullWidth: true)
        }
    }
}

#Preview {
    let section1 = PushNotificationsBoostBottomSheetViewModel.Section(
        icon: Image(.alarmOff),
        title: "Instant Updates",
        description: "Receive alerts the moment a buyer shows interest in your items."
    )
    let section2 = PushNotificationsBoostBottomSheetViewModel.Section(
        icon: Image(.alarmOff),
        title: "Quick Responses",
        description: "Respond faster to messages, increasing your chances of making a sale."
    )
    let section3 = PushNotificationsBoostBottomSheetViewModel.Section(
        icon: Image(.alarmOff),
        title: "Stay ahead",
        description: "Be the first to know when there’s a new match for your listings or a price drop on items you’re following."
    )

    let allowButton = PushNotificationsBoostBottomSheetViewModel.Button(
        kind: .allow,
        title: "Allow Push Notifications"
    )
    let notNowButton = PushNotificationsBoostBottomSheetViewModel.Button(
        kind: .notNow,
        title: "Not now"
    )

    let viewModel = PushNotificationsBoostBottomSheetViewModel(
        title: "Never miss a beat!",
        sections: [section1, section2, section3],
        buttons: [allowButton, notNowButton]
    )

    return PushNotificationsBoostBottomSheet(viewModel: viewModel)
}
