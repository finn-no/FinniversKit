import SwiftUI

public struct JobsTextFieldStyle: SwiftUI.TextFieldStyle {
    @FocusState var focused: Bool
    let title: String?
    let footer: String?

    /// - Parameter title: Text to be displayed above the text field
    /// - Parameter footer: Text to be displayed below the text field
    public init(title: String? = nil, footer: String? = nil) {
        self.title = title
        self.footer = footer
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

            if let footer {
                Text(footer)
                    .finnFont(.caption)
                    .foregroundColor(.textPrimary)
            }
        }
        .focused($focused)
        .animation(.snappy, value: focused)
    }
}

struct SwiftUITextFieldStyles_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUI.TextField("Batman", text: .constant(""))
            .textFieldStyle(
                JobsTextFieldStyle(title: "Name", footer: "Your real name or a nickname. We use this to personalise your experience in the app.")
            )
            .padding()
    }
}
