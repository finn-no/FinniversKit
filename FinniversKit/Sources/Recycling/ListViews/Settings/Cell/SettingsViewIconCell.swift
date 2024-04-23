import SwiftUI

struct SettingsViewIconCell: View {
    let title: String
    let icon: UIImage
    let tintColor: Color?
    let isLastItem: Bool

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
        }.hairlineDivider(!isLastItem)
    }
}

struct SettingsViewIconCell_Previews: PreviewProvider {
    static var previews: some View {
        SettingsViewIconCell(title: "Personvernerklæring", icon: .init(systemName: "square.and.arrow.up")!, tintColor: .bgSuccess, isLastItem: false) // swiftlint:disable:this force_unwrapping
    }
}

struct HairlineDividerModifier: ViewModifier {
    let isLastItem: Bool
    let inset: EdgeInsets

    public func body(content: Content) -> some View {
        ZStack {
            content
            if isLastItem {
                VStack {
                    Spacer()
                    Divider().padding(inset)
                }
            }
        }.listRowInsets(EdgeInsets())
    }
}

extension View {
    public func hairlineDivider(
        _ isLastItem: Bool,
        inset: EdgeInsets = EdgeInsets(top: 0, leading: .spacingM, bottom: 0, trailing: 0)
    ) -> some View {
        modifier(HairlineDividerModifier(isLastItem: isLastItem, inset: inset))
    }
}
