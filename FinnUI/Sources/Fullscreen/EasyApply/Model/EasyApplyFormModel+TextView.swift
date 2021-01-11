//
//  Copyright © 2021 FINN.no AS. All rights reserved.
//

import SwiftUI
import FinniversKit

@available(iOS 13.0, *)
extension EasyApplyFormModel {
    struct TextView: Swift.Identifiable {
        let id: UUID = UUID()
        let placeholder: String
        var value: String

        init(placeholder: String, value: String = "") {
            self.placeholder = placeholder
            self.value = value
        }
    }
}
