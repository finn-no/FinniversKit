//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI

public extension InfoboxSwiftUIView {
    enum InformationType {
        case critical
        case information
        case success
        case warning
        case custom(
            backgroundColor: Color,
            borderColor: Color?,
            sidebarColor: Color?,
            iconImage: Image?
        )

        var backgroundColor: Color {
            switch self {
            case .critical:
                Color.bgInformationCritical
            case .custom(let backgroundColor, _, _, _):
                backgroundColor
            case .information:
                Color.bgInformationInfo
            case .success:
                Color.bgInformationSuccess
            case .warning:
                Color.bgInformationAlert
            }
        }

        var sideboxColor: Color {
            switch self {
            case .critical:
                Color.sideboxCritical
            case .custom(_, _, let sideboxColor, _):
                sideboxColor ?? .clear
            case .information:
                Color.sideboxInfo
            case .success:
                Color.sideboxSuccess
            case .warning:
                Color.sideboxAlert
            }
        }

        var borderColor: Color {
            switch self {
            case .critical:
                Color.borderCritical
            case .custom(_, let borderColor, _, _):
                borderColor ?? .clear
            case .information:
                Color.borderInfo
            case .success:
                Color.borderSuccess
            case .warning:
                Color.borderAlert
            }
        }

        var icon: Image? {
            switch self {
            case .critical:
                Image(named: .infoboxCritical)
            case .information:
                Image(named: .infoboxInfo)
            case .success:
                Image(named: .infoboxSuccess)
            case .warning:
                Image(named: .infoboxWarning)
            case .custom(_, _, _, let iconImage):
                iconImage
            }
        }
    }
}

public struct InfoboxSwiftUIViewModel: Swift.Identifiable {
    public struct Interaction {
        public let title: String
        public let onTapped: () -> Void

        public init(title: String, onTapped: @escaping () -> Void) {
            self.title = title
            self.onTapped = onTapped
        }
    }

    public let id = UUID()
    public let informationType: InfoboxSwiftUIView.InformationType
    public let title: String
    public let detail: String
    public let linkInteraction: Interaction?
    public let primaryButtonInteraction: Interaction?
    public let secondaryButtonInteraction: Interaction?

    public init(
        informationType: InfoboxSwiftUIView.InformationType,
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

public struct InfoboxSwiftUIView: View {
    public let viewModel: InfoboxSwiftUIViewModel

    public init(viewModel: InfoboxSwiftUIViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Rectangle()
                .fill(viewModel.informationType.sideboxColor)
                .frame(width: 4)

            HStack(alignment: .top, spacing: 8) {

                viewModel.informationType.icon

                VStack(alignment: .leading, spacing: 8) {
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

                    HStack(spacing: 8) {
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

                Spacer()
            }
            .padding(.vertical, 16)

        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(viewModel.informationType.backgroundColor)
        .cornerRadius(4, corners: .allCorners)
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(viewModel.informationType.borderColor, lineWidth: 1.0)
        )
    }
}

#Preview {
    VStack {
        InfoboxSwiftUIView(viewModel: .mockCritical)
        InfoboxSwiftUIView(viewModel: .mockInfo)
        InfoboxSwiftUIView(viewModel: .mockInfoWithLinkAndButtons)
        InfoboxSwiftUIView(viewModel: .mockSuccess)
        InfoboxSwiftUIView(viewModel: .mockWarning)
        InfoboxSwiftUIView(viewModel: .mockCustom)
    }
    .padding()
}

private extension InfoboxSwiftUIViewModel {
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
                borderColor: .blue,
                sidebarColor: .green,
                iconImage: nil
            ),
            title: "Custom",
            detail: "Crazy colors"
        )
    }
}
