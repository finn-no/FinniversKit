import SwiftUI

struct SettingsViewIconCell: View {
    let title: String
    let icon: UIImage
    let tintColor: Color?

    var body: some View {
        HStack(alignment: .center) {
            Text(title)
                .finnFont(.body)
                .foregroundColor(.textPrimary)
                .padding([.leading])

            Spacer(minLength: .spacingS)

            Image(uiImage: icon)
                .resizable()
                .renderingMode(.template)
                .frame(width: .spacingM, height: .spacingM)
                .foregroundColor(tintColor)
                .padding([.trailing], .spacingXL)
        }
    }
}

struct SettingsViewIconCell_Previews: PreviewProvider {
    static var previews: some View {
        SettingsViewIconCell(title: "Personvernerklæring", icon: .init(systemName: "square.and.arrow.up")!, tintColor: .bgSuccess) // swiftlint:disable:this force_unwrapping
    }
}
