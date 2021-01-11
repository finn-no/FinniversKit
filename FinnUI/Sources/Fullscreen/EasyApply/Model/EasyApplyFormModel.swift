//
//  Copyright © 2021 FINN.no AS. All rights reserved.
//

import SwiftUI
import FinniversKit

@available(iOS 13.0, *)
class EasyApplyFormModel: ObservableObject {
    let name: String
    let position: String
    @Published var textfields: [TextField]
    @Published var questions: [Question]
    @Published var textviews: [TextView]
    @Published var educations: Educations

    init(name: String, position: String, textfields: [TextField], questions: [Question], textviews: [TextView], educations: Educations) {
        self.name = name
        self.position = position
        self.textfields = textfields
        self.questions = questions
        self.textviews = textviews
        self.educations = educations
    }
}
