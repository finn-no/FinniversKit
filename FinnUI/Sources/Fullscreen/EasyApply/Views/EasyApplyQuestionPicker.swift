//
//  Copyright © 2021 FINN.no AS. All rights reserved.
//

import SwiftUI
import FinniversKit

@available(iOS 13.0, *)
struct EasyApplyQuestionPicker: View {
    @Binding var select: EasyApplyQuestion

    var body: some View {
        Text(select.question)
            .finnFont(.bodyStrong)
            .foregroundColor(Color.textPrimary)

        Picker(selection: $select.selectedOption, label: Text(select.question)) {
            ForEach(EasyApplyQuestion.Option.allCases) { option in
                Text(option.displayValue).tag(option as EasyApplyQuestion.Option?)
            }
        }
        .foregroundColor(Color.textPrimary)
    }
}

