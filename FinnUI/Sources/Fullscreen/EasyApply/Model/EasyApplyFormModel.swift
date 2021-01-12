//
//  Copyright © 2021 FINN.no AS. All rights reserved.
//

import SwiftUI
import FinniversKit

@available(iOS 13.0, *)
class EasyApplyFormModel: ObservableObject, CustomStringConvertible {
    let position: String
    let profileData: ProfileData

    @Published var questions: [Question]
    @Published var educations: Educations
    @Published var textfields: [TextField]
    @Published var applicationLetter: TextView

    init(position: String, profileData: ProfileData, questions: [Question], educations: Educations) {
        self.position = position
        self.profileData = profileData
        self.questions = questions
        self.educations = educations

        self.applicationLetter = TextView(placeholder: "Søknadsbrev")

        self.textfields = [
            TextField(type: .default, placeholder: "Navn", value: profileData.name),
            TextField(type: .email, placeholder: "Epost", helpText: "Epost-adressen er ikke gyldig"),
            TextField(type: .phone, placeholder: "Telefon"),
            TextField(type: .number, placeholder: "Fødselsår"),
            TextField(type: .number, placeholder: "Postnummer", value: profileData.postalCode),
            TextField(type: .default, placeholder: "Nåværende eller siste stilling"),
        ]
    }

    var description: String {
        """
        \(textfields.map { $0.value })
        \(questions.map { $0.selectedOption })
        \(applicationLetter.value)
        \(educations.selectedEducation.name)
        """
    }
}
