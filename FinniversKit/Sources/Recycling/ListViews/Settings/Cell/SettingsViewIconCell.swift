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
                .foregroundColor(.text)
                .padding([.leading])

            Spacer(minLength: .spacingS)

            Image(uiImage: icon)
                .resizable()
                .renderingMode(.template)
                .frame(width: .spacingM, height: .spacingM)
                .foregroundColor(tintColor)
                .padding([.trailing], .spacingXL)
        }.bottomDivider(!isLastItem)
    }
}

extension View {
    func bottomDivider(
        _ isLastItem: Bool,
        inset: EdgeInsets = EdgeInsets(top: 0, leading: .spacingM, bottom: 0, trailing: 0)
    ) -> some View {
        modifier(BottomDivider(isLastItem: isLastItem, inset: inset))
    }
}

struct SettingsViewIconCell_Previews: PreviewProvider {
    static var previews: some View {
        SettingsViewIconCell(title: "Personvernerklæring", icon: .init(systemName: "square.and.arrow.up")!, tintColor: .backgroundPositiveSubtle, isLastItem: false) // swiftlint:disable:this force_unwrapping
    }
}

struct BottomDivider: ViewModifier {
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
