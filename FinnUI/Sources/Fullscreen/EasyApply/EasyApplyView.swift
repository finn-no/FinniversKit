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
                    EasyApplyEducationPicker(educations: $form.educations)
                    selects
                    textviews
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
            Text("Søk stilling som:")
                .finnFont(.detail)

            Text(form.position)
                .finnFont(.bodyStrong)
                .padding(.bottom, .spacingXS)

            Text("Du er logget inn som:")
                .finnFont(.caption)

            Text(form.name)
                .finnFont(.bodyRegular)
        }.foregroundColor(Color.textPrimary)
    }

    var textfields: some View {
        VStack(alignment: .leading) {
            ForEach(form.textfields) {
                FinnTextField(
                    input: $0.type,
                    placeholder: $0.placeholder,
                    helpText: $0.helpText,
                    text: binding(for: $0, in: \.textfields).value
                )
            }
        }
    }

    var selects: some View {
        VStack(alignment: .leading) {
            ForEach(form.questions) {
                EasyApplyQuestionPicker(select: binding(for: $0, in: \.questions))
            }
        }.pickerStyle(SegmentedPickerStyle())
    }

    var textviews: some View {
        VStack(alignment: .leading) {
            ForEach(form.textviews) {
                FinnTextView(
                    placeholder: $0.placeholder,
                    text: binding(for: $0, in: \.textviews).value
                )
                .frame(minHeight: 150)
            }
        }
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

    private func binding<Item: Swift.Identifiable>(for item: Item, in list: KeyPath<ObservedObject<EasyApplyFormModel>.Wrapper, Binding<[Item]>>) -> Binding<Item> {
        guard let index = $form[keyPath: list].wrappedValue.firstIndex(where: { $0.id == item.id }) else {
            fatalError("Can't find item in list")
        }

        return $form[keyPath: list][index]
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
                    EasyApplyFormModel.TextField(type: .default, placeholder: "Navn", value: "Test Testesen"),
                    EasyApplyFormModel.TextField(type: .email, placeholder: "Epost", helpText: "Epost-adressen er ikke gyldig"),
                    EasyApplyFormModel.TextField(type: .phone, placeholder: "Telefon"),
                ],
                questions: [
                    EasyApplyFormModel.Question(question: "Er du student eller nyutdannet?"),
                    EasyApplyFormModel.Question(question: "Har du erfaring med programvareutvikling?"),
                ],
                textviews: [
                    EasyApplyFormModel.TextView(placeholder: "Søknadsbrev")
                ],
                educations: EasyApplyFormModel.Educations()
            )
        )
        .colorScheme(.light)
        .previewLayout(.device)
    }
}
