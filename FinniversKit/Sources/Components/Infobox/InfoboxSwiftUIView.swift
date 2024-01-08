//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import SwiftUI

public struct InfoboxSwiftUIView: View {
    public let style: InfoboxView.Style
    public var viewModel: InfoboxViewModel?
    public var onPrimaryButtonTapped: (() -> Void)?
    public var onSecondaryButtonTapped: (() -> Void)?

    public init(
        style: InfoboxView.Style,
        viewModel: InfoboxViewModel? = nil,
        onPrimaryButtonTapped: (() -> Void)? = nil,
        onSecondaryButtonTapped: (() -> Void)? = nil
    ) {
        self.style = style
        self.viewModel = viewModel
        self.onPrimaryButtonTapped = onPrimaryButtonTapped
        self.onSecondaryButtonTapped = onSecondaryButtonTapped
    }

    public var body: some View {
        VStack(alignment: .center, spacing: .spacingM) {
            if let viewModel {
                Text(viewModel.title)
                    .finnFont(style.titleStyle)
                Text(viewModel.detail)
                    .finnFont(style.detailStyle)

                VStack(spacing: .spacingXS) {
                    primaryButton(for: viewModel)

                    secondaryButton(for: viewModel)
                }
            }
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, .spacingXL)
        .padding(.vertical, .spacingM)
        .frame(maxWidth: .infinity)
        .foregroundStyle(Color(uiColor: style.textColor))
        .background(Color(uiColor: style.backgroundColor))
        .cornerRadius(8)
    }

    @ViewBuilder
    private func primaryButton(for viewModel: InfoboxViewModel) -> some View {
        if viewModel.primaryButtonTitle.isEmpty {
            SwiftUI.EmptyView()
        } else {
            SwiftUI.Button(
                action: { onPrimaryButtonTapped?() },
                label: {
                    Group {
                        if let primaryButtonIcon = style.primaryButtonIcon {
                            HStack {
                                Spacer()
                                Text(viewModel.primaryButtonTitle)
                                Spacer()
                                Image(uiImage: primaryButtonIcon)
                            }
                        } else {
                            Text(viewModel.primaryButtonTitle)
                        }
                    }
                }
            )
            .primaryButtonStyle(for: style)
        }
    }

    @ViewBuilder
    private func secondaryButton(for viewModel: InfoboxViewModel) -> some View {
        if viewModel.secondaryButtonTitle.isEmpty {
            SwiftUI.EmptyView()
        } else {
            SwiftUI.Button(
                action: { onSecondaryButtonTapped?() },
                label: { Text(viewModel.secondaryButtonTitle) }
            )
            .secondaryButtonStyle(for: style)
        }
    }
}

#Preview {
    InfoboxSwiftUIView(
        style: .normal(
            backgroundColor: .bgSecondary,
            primaryButtonIcon: UIImage(named: .webview)
        ),
        viewModel: MockInfoboxViewModel.mock
    )
}

private struct MockInfoboxViewModel: InfoboxViewModel {
    var title: String
    var detail: String
    var primaryButtonTitle: String
    var secondaryButtonTitle: String

    static var mock: Self {
        .init(
            title: "Slipp å avtale møte med selger",
            detail: "Med FINN levert hjelper vi selger å sende varen til deg, enten hjemme eller i butikk.",
            primaryButtonTitle: "Slik funker FINN levert",
            secondaryButtonTitle: "Se alle fraktalternativer"
        )
    }
}
