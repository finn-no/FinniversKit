//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import SwiftUI
import FinniversKit

@available(iOS 13.0, *)
struct PhoneNumberView: View {
    let viewModel: PhoneNumberViewModel
    @SwiftUI.State var showPhoneNumber: Bool = false
    var contact: (() -> Void) = {}

    var buttonTitle: String {
        showPhoneNumber ? viewModel.phoneNumber : viewModel.revealTitle
    }

    var body: some View {
        HStack {
            Text(viewModel.sectionTitle)
                .finnFont(.body)
                .foregroundColor(.textSecondary)

            Spacer()

            Button(buttonTitle, action: togglePhoneNumber)
                .buttonStyle(InlineFlatStyle())
        }
        .padding(.vertical, .spacingS)
    }

    private func togglePhoneNumber() {
        if showPhoneNumber {
            contact()
        } else {
            showPhoneNumber = true
        }
    }
}

@available(iOS 13.0.0, *)
//swiftlint:disable:next type_name
struct PhoneNumberView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PhoneNumberView(viewModel: .sampleData)

            PhoneNumberView(viewModel: .sampleData, showPhoneNumber: true)
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
