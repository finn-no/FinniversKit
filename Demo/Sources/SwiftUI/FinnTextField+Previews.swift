//
//  Copyright © 2021 FINN.no AS. All rights reserved.
//

import SwiftUI
import FinniversKit
import DemoKit
import Warp

struct FinnTextFieldDemoView: View {

    @SwiftUI.State var text: String = ""

    var body: some View {
        ScrollView {
            Text("Textfields")
                .font(from: .title1)
                .padding(.bottom, Warp.Spacing.spacing200)

            FinnTextField(placeholder: "Default", text: $text)
            FinnTextField(input: .email, placeholder: "Email", helpText: "Help text", text: $text)
            FinnTextField(input: .secure, placeholder: "Secure", helpText: "Help text", text: $text)
            FinnTextField(input: .phone, placeholder: "Phone", text: $text)
            FinnTextField(input: .number, placeholder: "Number", text: $text)
            FinnTextField(
                placeholder: "Enter the text \"il tempo gigante\"",
                helpText: "Felgens svar på italienske Ferrari",
                text: $text,
                validator: { text in
                    text.lowercased() == "il tempo gigante"
                }
            )

            Spacer()
        }
    }
}

// swiftlint:disable:next superfluous_disable_command type_name
struct FinnTextField_Previews: PreviewProvider, Demoable {
    static var previews: some View {
        FinnTextFieldDemoView()
            .padding(Warp.Spacing.spacing200)
            .previewLayout(.sizeThatFits)
    }
}
