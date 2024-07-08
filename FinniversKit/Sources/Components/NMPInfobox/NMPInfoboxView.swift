//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI
import Warp

public extension NMPInfoboxView {
    /**
     ViewModel for the NMPInfoboxView

     This allows you to populate the info box with:

     - an`InformationType` `enum` for this view
     - a title
     - a detail message
     - optional link, primary and secondary `Interaction`s  if needed

     */
    struct ViewModel: Swift.Identifiable {
        public struct Interaction {
            public let title: String
            public let onTapped: () -> Void

            public init(title: String, onTapped: @escaping () -> Void) {
                self.title = title
                self.onTapped = onTapped
            }
        }

        public let id = UUID()
        public let informationType: NMPInfoboxView.InformationType
        public let title: String
        public let detail: String
        public let linkInteraction: Interaction?
        public let primaryButtonInteraction: Interaction?
        public let secondaryButtonInteraction: Interaction?

        public init(
            informationType: NMPInfoboxView.InformationType,
            title: String,
            detail: String,
            linkInteraction: Interaction? = nil,
            primaryButtonInteraction: Interaction? = nil,
            secondaryButtonInteraction: Interaction? = nil
        ) {
            self.informationType = informationType
            self.title = title
            self.detail = detail
            self.linkInteraction = linkInteraction
            self.primaryButtonInteraction = primaryButtonInteraction
            self.secondaryButtonInteraction = secondaryButtonInteraction
        }

        var titleStyle: Label.Style {
            .bodyStrong
        }

        var detailStyle: Label.Style {
            .body
        }
    }
}

/**
 A SwiftUI view to match the Warp Infobox component,

 - Parameters:
    - viewModel: A `NMPInfobox.ViewModel` to configure the Infobox
 */
public struct NMPInfoboxView: View {
    public let viewModel: ViewModel
    private let cornerRadius: Double = 4

    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        HStack(alignment: .top, spacing: .spacingS) {

            viewModel.informationType.icon

            VStack(alignment: .leading, spacing: .spacingS) {
                Text(viewModel.title)
                    .finnFont(viewModel.titleStyle)
                Text(viewModel.detail)
                    .finnFont(viewModel.detailStyle)

                if let linkInteraction = viewModel.linkInteraction {
                    SwiftUI.Button(
                        action: { linkInteraction.onTapped() },
                        label: {
                            Text(linkInteraction.title).underline()
                        }
                    )
                    .buttonStyle(InlineFlatStyle())
                }

                HStack(spacing: .spacingS) {
                    if let primaryButtonInteraction = viewModel.primaryButtonInteraction {
                        SwiftUI.Button(
                            action: { primaryButtonInteraction.onTapped() },
                            label: {
                                Text(primaryButtonInteraction.title)
                            }
                        )
                        .buttonStyle(DefaultStyle(fullWidth: false))
                    }

                    if let secondaryButtonInteraction = viewModel.secondaryButtonInteraction {
                        SwiftUI.Button(
                            action: { secondaryButtonInteraction.onTapped() },
                            label: { Text(secondaryButtonInteraction.title) }
                        )
                        .buttonStyle(FlatStyle(fullWidth: false))
                    }

                    Spacer()
                }
            }

        }
        .padding(Warp.Spacing.spacing200)
        .overlay( // border
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(viewModel.informationType.subtleBorderColor, lineWidth: 1)
        )
        .overlay( // sidebar
            Rectangle()
                .fill(viewModel.informationType.borderColor)
                .frame(width: .spacingXS),
            alignment: .leading
        )
        .frame(maxWidth: .infinity)
        .background(viewModel.informationType.backgroundColor)
        .cornerRadius(cornerRadius)
    }
}

#Preview {
    VStack {
        NMPInfoboxView(viewModel: .mockCritical)
        NMPInfoboxView(viewModel: .mockInfo)
        NMPInfoboxView(viewModel: .mockInfoWithLinkAndButtons)
        NMPInfoboxView(viewModel: .mockSuccess)
        NMPInfoboxView(viewModel: .mockWarning)
        NMPInfoboxView(viewModel: .mockCustom)
    }
}

private extension NMPInfoboxView.ViewModel {
    static var mockCritical: Self {
        .init(
            informationType: .critical,
            title: "Critical",
            detail: "And something here"
        )
    }

    static var mockInfo: Self {
        .init(
            informationType: .information,
            title: "Information",
            detail: "And something here"
        )
    }

    static var mockInfoWithLinkAndButtons: Self {
        .init(
            informationType: .information,
            title: "Information",
            detail: "And something here",
            linkInteraction: .init(
                title: "Link",
                onTapped: {}
            ),
            primaryButtonInteraction: .init(
                title: "Primary",
                onTapped: {}
            ),
            secondaryButtonInteraction: .init(
                title: "Secondary",
                onTapped: {}
            )
        )
    }

    static var mockSuccess: Self {
        .init(
            informationType: .success,
            title: "Success",
            detail: "And something here"
        )
    }

    static var mockWarning: Self {
        .init(
            informationType: .warning,
            title: "Warning",
            detail: "And something here"
        )
    }

    static var mockCustom: Self {
        .init(
            informationType: .custom(
                backgroundColor: .red,
                subtleBorderColor: .blue,
                borderColor: .green,
                iconImage: nil
            ),
            title: "Custom",
            detail: "Crazy colors"
        )
    }
}
