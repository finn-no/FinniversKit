//
//  Copyright © 2021 FINN.no AS. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct EasyApplyQuestion: Identifiable {
    enum Option: String, Identifiable, CaseIterable {
        case yes
        case no

        var id: String { self.rawValue }

        var displayValue: String {
            switch self {
            case .yes: return "Ja"
            case .no: return "No"
            }
        }
    }

    let id: String = UUID().uuidString
    let question: String
    var selectedOption: Option?

    init(question: String) {
        self.question = question
    }

}

