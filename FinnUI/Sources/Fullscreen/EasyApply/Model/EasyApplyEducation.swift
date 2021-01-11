//
//  Copyright © 2021 FINN.no AS. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct EasyApplyEducations {

    struct Education: Identifiable, Hashable {
        let id: UUID = UUID()
        let name: String
    }

    let educations: [Education] = [
        .init(name: ""),
        .init(name: "Grunnskole"),
        .init(name: "Fagskole"),
        .init(name: "Høyere utdanning, 1-4 år")
    ]

    var selectedEducation: Education

    init() {
        selectedEducation = educations.first!
    }


}
