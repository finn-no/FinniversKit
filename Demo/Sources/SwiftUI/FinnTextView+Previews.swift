//
//  Copyright © 2021 FINN.no AS. All rights reserved.
//

import SwiftUI
import FinniversKit

struct FinnTextViewDemoView: View {

    @SwiftUI.State var text: String = ""

    var body: some View {
        VStack {
            Text("Textviews")
                .finnFont(.title1)
                .padding(.bottom, .spacingM)

            FinnTextView(text: $text).frame(height: 100)
            FinnTextView(placeholder: "Placeholder", text: $text).frame(height: 100)

            Spacer()
        }
    }
}

// swiftlint:disable:next superfluous_disable_command type_name
struct FinnTextView_Previews: PreviewProvider {
    static var previews: some View {
        FinnTextViewDemoView()
            .padding(.spacingM)
            .previewLayout(.sizeThatFits)
    }
}
