//
//  Copyright © 2021 FINN.no AS. All rights reserved.
//

import SwiftUI
import FinniversKit

@available(iOS 13.0, *)
class EasyApplyFormModel: ObservableObject, CustomStringConvertible {
    let position: String
    let profileData: ProfileData

    @Published var textfields: [TextField]
    @Published var questions: [Question]
    @Published var textviews: [TextView]
    @Published var educations: Educations

    init(position: String, profileData: ProfileData, questions: [Question], educations: Educations) {
        self.position = position
        self.profileData = profileData
        self.questions = questions

        self.textfields = [
            TextField(type: .default, placeholder: "Navn", value: profileData.name),
            TextField(type: .email, placeholder: "Epost", helpText: "Epost-adressen er ikke gyldig"),
            TextField(type: .phone, placeholder: "Telefon"),
            TextField(type: .number, placeholder: "Fødselsår"),
            TextField(type: .number, placeholder: "Postnummer", value: profileData.postalCode),
            TextField(type: .default, placeholder: "Nåværende eller siste stilling"),
        ]

        self.textviews = [
            TextView(placeholder: "Søknadsbrev")
        ]

        self.educations = educations
    }

    var description: String {
        """
        \(textfields.map { $0.value })
        \(questions.map { $0.selectedOption })
        \(textviews.map { $0.value })
        \(educations.selectedEducation.name)
        """
    }
}
