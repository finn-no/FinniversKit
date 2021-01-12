//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import SwiftUI
import FinniversKit

// This is not production ready. This is stored as the result of an experiment, and hence not public.
@available(iOS 13.0, *)
struct EasyApplyView: View {

    @ObservedObject var form: EasyApplyFormModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: .spacingM + .spacingS) {
                    header.padding(.bottom, .spacingS)
                    textfields
                    educationPicker
                    questions
                    applicationLetter
                }
                .padding(.top, .spacingS)

                Spacer()

                applyButton
            }
            .padding(.horizontal, .spacingM)
        }
    }

    @ViewBuilder var loggedInUser: some View {
        if let name = form.profileData.name {
            Text("Du er logget inn som:")
                .finnFont(.caption)

            Text(name)
                .finnFont(.bodyRegular)
        }
    }

    var header: some View {
        VStack(alignment: .leading) {
            Text("Søk stilling som:")
                .finnFont(.detail)

            Text(form.position)
                .finnFont(.bodyStrong)
                .padding(.bottom, .spacingXS)

            loggedInUser

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

    var educationPicker: some View {
        EasyApplyEducationPicker(educations: $form.educations)
    }

    var questions: some View {
        VStack(alignment: .leading) {
            ForEach(form.questions) {
                EasyApplyQuestionPicker(select: binding(for: $0, in: \.questions))
            }
        }.pickerStyle(SegmentedPickerStyle())
    }

    var applicationLetter: some View {
        VStack(alignment: .leading) {
            Text("Søkertekst")
                .finnFont(.captionStrong)
                .foregroundColor(Color.textPrimary)

            FinnTextView(
                placeholder: form.applicationLetter.placeholder,
                text: $form.applicationLetter.value
            )
            .frame(minHeight: 150)
        }
    }

    var applyButton: some View {
        Button(action: {
            print(form)
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
                position: "Utvikler (arkitekt)",
                profileData: EasyApplyFormModel.ProfileData(name: "Test Testesen", postalCode: "0485"),
                questions: [
                    EasyApplyFormModel.Question(question: "Er du student eller nyutdannet?"),
                    EasyApplyFormModel.Question(question: "Har du erfaring med programvareutvikling?"),
                ],
                educations: EasyApplyFormModel.Educations()
            )
        )
        .colorScheme(.light)
        .previewLayout(.device)
    }
}
