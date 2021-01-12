//
//  Copyright © 2021 FINN.no AS. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
extension EasyApplyFormModel {
    struct ProfileData {
        let name: String?
        let birthYear: String?
        let postalCode: String?

        init(name: String? = nil, birthYear: String? = nil, postalCode: String? = nil) {
            self.name = name
            self.birthYear = birthYear
            self.postalCode = postalCode
        }
    }
}
