//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import SwiftUI
import FinniversKit

@available(iOS 13.0, *)
struct DescriptionView: View {
    let viewModel: DescriptionViewModel
    @SwiftUI.State var isExpanded: Bool = false

    var lineLimit: Int? {
        isExpanded ? nil : 15
    }

    var buttonLabel: String {
        isExpanded ? viewModel.collapseButtonTitle : viewModel.expandButtonTitle
    }

    var body: some View {
        Group {
            if viewModel.content.underestimatedCount > 500 {
                VStack(alignment: .leading, spacing: .spacingS) {
                    textContent

                    Button(buttonLabel, action: toggleDescription)
                        .buttonStyle(InlineFlatStyle())
                }
            } else {
                textContent
            }
        }
        .foregroundColor(.textPrimary)
        .padding(.horizontal, .spacingS)
    }

    private var textContent: some View {
        Text(viewModel.content)
            .lineSpacing(6)
            .lineLimit(lineLimit)
            .finnFont(.body)
    }

    private func toggleDescription() {
        isExpanded.toggle()
    }
}

@available(iOS 13.0, *)
struct DescriptionView_Previews: PreviewProvider {
    static let ad = BapAdViewModel.sampleData

    static var previews: some View {
        Group {
            ScrollView {
                DescriptionView(viewModel: .sampleData)
                    .padding(.horizontal, .spacingS)
            }

            ScrollView {
                DescriptionView(viewModel: .sampleData, isExpanded: true)
                    .padding(.horizontal, .spacingS)
            }

            ScrollView {
                DescriptionView(viewModel: .sampleData)
                    .padding(.horizontal, .spacingS)
            }
            .background(Color.bgPrimary)
            .colorScheme(.dark)
        }
        .previewLayout(.sizeThatFits)
    }
}
