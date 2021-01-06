//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import SwiftUI
import FinniversKit

@available(iOS 13.0, *)
class EasyApplyViewModel: ObservableObject {

    @Published var name: String
    @Published var email: String = ""
    @Published var phone: String = ""
    @Published var birthYear: String = ""
    @Published var postalCode: String = ""
    @Published var currentPosition = ""

    init(name: String = "") {
        self.name = name
    }
}

@available(iOS 14.0, *)
struct EasyApplyView: View {

    @ObservedObject var model: EasyApplyViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {

                VStack(alignment: .leading) {
                    Text("Søk stilling som:").finnFont(.detail)
                    Text("Systemutvikler / softwareutvikler i Krabbe AS").finnFont(.bodyStrong)
                }
                .padding(.bottom, .spacingS)

                VStack(alignment: .leading) {
                    Text("Du er logget inn som:").finnFont(.caption)
                    Text(model.name).finnFont(.bodyRegular)
                }

                VStack(alignment: .leading, spacing: .spacingM) {
                    FinnTextField(placeholder: "Navn", text: $model.name)
                    FinnTextField(input: .email, placeholder: "Epost", helpText: "Må være en gyldig epost-adresse", text: $model.email)
                    FinnTextField(input: .phone, placeholder: "Telefon", text: $model.phone)
                    FinnTextField(input: .number, placeholder: "Fødselsår", text: $model.birthYear)
                    FinnTextField(input: .number, placeholder: "Postnummer", text: $model.postalCode)
                    FinnTextField(placeholder: "Nåværende eller siste stilling", text: $model.currentPosition)
                }
                .padding(.top, .spacingS)

                Spacer()
            }
            .padding(.horizontal, .spacingM)
        }
    }
}

@available(iOS 14.0, *)
struct EasyApplyView_Previews: PreviewProvider {
    static var previews: some View {
        EasyApplyView(model: EasyApplyViewModel(name: "Test Testesen"))
            .colorScheme(.light)
            .previewLayout(.device)
    }
}
