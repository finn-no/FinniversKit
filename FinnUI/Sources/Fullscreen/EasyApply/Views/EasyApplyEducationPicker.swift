//
//  Copyright © 2021 FINN.no AS. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
struct EasyApplyEducationPicker: View {

    @Binding var educations: EasyApplyEducations
    @State private var isShowingPicker: Bool = false

    var selectedEducationLabel: some View {
        Text(educations.selectedEducation.name.isEmpty ? "Velg utdanning" : educations.selectedEducation.name)
            .finnFont(.body)
    }

    var expandIcon: some View {
        Image(.arrowDown)
            .rotationEffect(.degrees(isShowingPicker ? 180 : 0))
    }

    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                withAnimation {
                    isShowingPicker.toggle()
                }
            }, label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Utdanning: ").finnFont(.captionStrong)
                        selectedEducationLabel
                    }

                    Spacer()

                    expandIcon
                }
            })
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(Color.textPrimary)

            if isShowingPicker {
                Picker(selection: $educations.selectedEducation, label: Text("Utdanning")) {
                    ForEach(educations.educations) {
                        Text($0.name).tag($0 as EasyApplyEducations.Education)
                    }
                }
                .pickerStyle(DefaultPickerStyle())
                .foregroundColor(Color.textPrimary)
            }
        }
    }
}
