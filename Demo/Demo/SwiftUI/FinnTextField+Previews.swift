//
//  Copyright © 2021 FINN.no AS. All rights reserved.
//

import SwiftUI
import FinniversKit

@available(iOS 13.0, *)
struct FinnTextFieldDemoView: View {

    @SwiftUI.State var text: String = ""

    var body: some View {
        VStack {
            Text("Textfields")
                .finnFont(.title1)
                .padding(.bottom, .spacingM)

            FinnTextField(placeholder: "Default", text: $text)
            FinnTextField(input: .email, placeholder: "Email", helpText: "Help text", text: $text)
            FinnTextField(input: .secure, placeholder: "Secure", helpText: "Help text", text: $text)
            FinnTextField(input: .phone, placeholder: "Phone", text: $text)
            FinnTextField(input: .number, placeholder: "Number", text: $text)

            Spacer()
        }
    }
}

@available(iOS 13.0, *)
// swiftlint:disable:next superfluous_disable_command type_name
struct FinnTextField_Previews: PreviewProvider {
    static var previews: some View {
        FinnTextFieldDemoView()
            .padding(.spacingM)
            .previewLayout(.sizeThatFits)
    }
}
