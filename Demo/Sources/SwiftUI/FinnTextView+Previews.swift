//
//  Copyright © 2021 FINN.no AS. All rights reserved.
//

import SwiftUI
import FinniversKit
import Warp

struct FinnTextViewDemoView: View {

    @SwiftUI.State var text: String = ""

    var body: some View {
        VStack {
            Text("Textviews")
                .font(from: .title1)
                .padding(.bottom, Warp.Spacing.spacing200)

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
            .padding(Warp.Spacing.spacing200)
            .previewLayout(.sizeThatFits)
    }
}
