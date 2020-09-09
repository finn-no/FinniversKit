//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import SwiftUI
import FinniversKit

@available(iOS 13.0, *)
struct TryHeltHjemView: View {
    let viewModel: TryHeltHjemViewModel
    let onReadMore: (() -> Void)
    let onAlternatives: (() -> Void)

    init(
        viewModel: TryHeltHjemViewModel,
        onReadMore: (() -> Void)? = nil,
        onAlternatives: (() -> Void)? = nil
    ) {
        self.viewModel = viewModel
        self.onReadMore = onReadMore ?? {}
        self.onAlternatives = onAlternatives ?? {}
    }

    var body: some View {
        VStack(spacing: .spacingM) {
            VStack {
                Text(viewModel.title)
                    .finnFont(.bodyStrong)
                Text(viewModel.description)
                    .finnFont(.caption)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: .spacingXS) {
                HStack {
                    Spacer()
                    Button(viewModel.ctaButtonTitle, action: onReadMore)
                        .buttonStyle(DefaultStyle(size: .small))
                    Spacer()
                }
                Button(viewModel.readMoreButtonTitle, action: onReadMore)
                    .buttonStyle(FlatStyle(size: .small))
            }
        }
        .foregroundColor(.textPrimary)
        .padding(.spacingM)
        .background(Color.bgSecondary)
        .cornerRadius(.spacingS)
    }
}

@available(iOS 13.0, *)
//swiftlint:disable:next type_name superfluous_disable_command
struct TryHeltHjemView_Previews: PreviewProvider {
    static var previews: some View {
        TryHeltHjemView(viewModel: .sampleData)
    }
}
