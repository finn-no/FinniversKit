import SwiftUI

public struct JobsTextFieldStyle: SwiftUI.TextFieldStyle {
    @FocusState var focused: Bool
    let title: String?

    public init(title: String? = nil) {
        self.title = title
    }

    public func _body(configuration: SwiftUI.TextField<Self._Label>) -> some View {
        VStack(alignment: .leading, spacing: .spacingXS) {
            if let title {
                Text(title)
                    .finnFont(.captionStrong)
                    .foregroundColor(.textPrimary)
            }

            configuration
                .finnFont(.bodyRegular)
                .foregroundColor(.textPrimary)
                .padding(.spacingM)
                .overlay(
                    RoundedRectangle(cornerRadius: .spacingXS, style: .continuous)
                        .stroke(focused ? Color.btnPrimary : Color.borderDefault, lineWidth: 1)
                )
        }
        .focused($focused)
        .animation(.snappy, value: focused)
    }
}

struct SwiftUITextFieldStyles_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUI.TextField("Batman", text: .constant(""))
            .textFieldStyle(
                JobsTextFieldStyle(title: "Name")
            )
            .padding()
    }
}
