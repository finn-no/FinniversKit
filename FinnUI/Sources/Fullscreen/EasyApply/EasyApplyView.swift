//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import SwiftUI
import FinniversKit

@available(iOS 13.0, *)
struct EasyApplyView: View {

    @ObservedObject var form: EasyApplyFormModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: .spacingM) {
                    header.padding(.bottom, .spacingS)
                    textfields
                    selects
                }
                .padding(.top, .spacingS)

                Spacer()

                applyButton
            }
            .padding(.horizontal, .spacingM)
        }
    }

    var header: some View {
        VStack(alignment: .leading) {
            Text("Søk stilling som:").finnFont(.detail)
            Text(form.position).finnFont(.bodyStrong)
                .padding(.bottom, .spacingXS)

            Text("Du er logget inn som:").finnFont(.caption)
            Text(form.name).finnFont(.bodyRegular)
        }
    }

    var textfields: some View {
        VStack(alignment: .leading) {
            ForEach(form.textfields) {
                FinnTextField(input: $0.type, placeholder: $0.placeholder, helpText: $0.helpText, text: binding(for: $0).value)
            }
        }
    }

    var selects: some View {
        VStack(alignment: .leading) {
            ForEach(form.questions) {
                EasyApplyQuestionPicker(select: binding(for: $0))
            }
        }.pickerStyle(SegmentedPickerStyle())
    }

    var applyButton: some View {
        Button(action: {
            form.textfields.forEach { print($0.value) }
            form.questions.forEach { print($0.selectedOption) }
        }, label: {
            Text("Søk på stilling")
        })
        .buttonStyle(CallToAction())
    }

    private func binding(for textfield: EasyApplyTextField) -> Binding<EasyApplyTextField> {
        guard let index = form.textfields.firstIndex(where: { $0.id == textfield.id }) else {
            fatalError("Can't find textfield in array")
        }

        return $form.textfields[index]
    }

    private func binding(for select: EasyApplyQuestion) -> Binding<EasyApplyQuestion> {
        guard let index = form.questions.firstIndex(where: { $0.id == select.id }) else {
            fatalError("Can't find select in array")
        }

        return $form.questions[index]
    }

}

@available(iOS 13.0, *)
struct EasyApplyView_Previews: PreviewProvider {
    static var previews: some View {
        EasyApplyView(
            form: EasyApplyFormModel(
                name: "Test Testesen",
                position: "Systemutvikler i FINN.no AS",
                textfields: [
                    EasyApplyTextField(type: .default, placeholder: "Navn", value: "Test Testesen"),
                    EasyApplyTextField(type: .email, placeholder: "Epost", helpText: "Epost-adressen er ikke gyldig"),
                    EasyApplyTextField(type: .phone, placeholder: "Telefon"),
                ],
                selects: [
                    EasyApplyQuestion(question: "Er du student eller nyutdannet?"),
                    EasyApplyQuestion(question: "Har du erfaring med programvareutvikling?"),
                ]
            )
        )
        .colorScheme(.light)
        .previewLayout(.device)
    }
}
