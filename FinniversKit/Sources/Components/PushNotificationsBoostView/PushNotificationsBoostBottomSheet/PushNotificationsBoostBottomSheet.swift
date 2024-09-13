import SwiftUI
import Warp

public struct PushNotificationsBoostBottomSheet: View {
    let viewModel: PushNotificationsBoostBottomSheetViewModel

    public init(viewModel: PushNotificationsBoostBottomSheetViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        if let cancelButtonTitle = viewModel.cancelButtonTitle {
            HStack {
                Spacer()

                Text(cancelButtonTitle)
                    .finnFont(.bodyStrong)
                    .foregroundColor(.textLink)
                    .padding([.top, .trailing])
                    .onTapGesture {
                        viewModel.dismiss?()
                    }
            }
        }
        VStack(alignment: .center, spacing: Warp.Spacing.spacing200) {
            Text(viewModel.title)
                .font(.finnFont(.title3Strong))
                .padding(.top)

            ForEach(viewModel.sections, id: \.self) {
                sectionView($0)
                    .padding([.leading, .trailing])
            }.padding(.top)

            VStack {
                ForEach(viewModel.buttons, id: \.self) {
                    buttonView($0)
                        .padding([.leading, .trailing])
                }
            }.padding([.top, .bottom])
        }.padding(.top)
    }
}

private extension PushNotificationsBoostBottomSheet {
    private func sectionView(_ section: PushNotificationsBoostBottomSheetViewModel.Section) -> some View {
        HStack(alignment: .center, spacing: Warp.Spacing.spacing200) {
            section.icon
                .padding(.leading)

            VStack(alignment: .leading, spacing: Warp.Spacing.spacing50) {
                Text(section.title)
                    .finnFont(.captionStrong)
                    .fixedSize(horizontal: false, vertical: true)
                Text(section.description)
                    .finnFont(.caption)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()
        }
    }

    private func buttonView(_ button: PushNotificationsBoostBottomSheetViewModel.Button) -> some View {
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
    let section1 = PushNotificationsBoostBottomSheetViewModel.Section(
        icon: Image(named: .bell),
        title: "Instant Updates",
        description: "Receive alerts the moment a buyer shows interest in your items."
    )
    let section2 = PushNotificationsBoostBottomSheetViewModel.Section(
        icon: Image(named: .bell),
        title: "Quick Responses",
        description: "Respond faster to messages, increasing your chances of making a sale."
    )
    let section3 = PushNotificationsBoostBottomSheetViewModel.Section(
        icon: Image(named: .bell),
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
        cancelButtonTitle: "Cancel",
        sections: [section1, section2, section3],
        buttons: [allowButton, notNowButton]
    )

    return PushNotificationsBoostBottomSheet(viewModel: viewModel)
}
