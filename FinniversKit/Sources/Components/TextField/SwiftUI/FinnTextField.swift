//
//  Copyright © 2020 FINN AS. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
public struct FinnTextField: View {

    public typealias CustomValidator = (String) -> Bool

    let input: Input
    let placeholder: String
    let helpText: String?

    @Binding var text: String
    @State var style: Style = .default

    let validator: CustomValidator?

    public init(
        input: Input = .default,
        placeholder: String,
        helpText: String? = nil,
        text: Binding<String>,
        validator: CustomValidator? = nil
    ) {
        self.input = input
        self.placeholder = placeholder
        self.helpText = helpText
        self._text = text
        self.validator = validator
    }

    private func updateStyle(_ style: Style) {
        withAnimation(.easeInOut(duration: 0.25)) {
            self.style = style
        }
    }

    private var shouldShowHelpText: Bool {
        if input == .email || input == .phone {
            return style == .error
        }

        return validator != nil
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Text(placeholder)
                .finnFont(.captionStrong)
                .foregroundColor(Color.textPrimary)

            TextFieldComponent(
                input: input,
                placeholder: placeholder,
                text: $text,
                onEditingChanged: { editing in updateStyle(editing ? .focused : .default) },
                onCommit: { evaluateTextState() }
            )
            .fixedSize(horizontal: false, vertical: true)
            .padding(.vertical, .spacingS + .spacingXS)
            .padding(.horizontal, .spacingS)
            .background(Color.bgSecondary)
            .overlay(underline, alignment: .bottom)
            .overlay(clearButton, alignment: .trailing)

            makeHelpTextLabel()
        }
    }

    private var underline: some View {
        Rectangle()
            .frame(height: style.underlineHeight)
            .foregroundColor(style.underlineColor)
    }

    @ViewBuilder
    private func makeHelpTextLabel() -> some View {
        let label = Text(helpText ?? "")
            .finnFont(.detail)
            .foregroundColor(style.helpTextColor)
            .transition(.asymmetricSlide)
            .padding(.top, 0)
            .padding(.bottom, 1)

        if shouldShowHelpText {
            label
        } else {
            label.hidden()
        }
    }

    @ViewBuilder
    private var clearButton: some View {
        if input == .default && style == .focused {
            SwiftUI.Button(action: {
                text = ""
            }, label: {
                Image(.remove)
                    .renderingMode(.template)
                    .foregroundColor(Color.iconPrimary)
                    .padding(.trailing, .spacingXS)
            })
        }
    }
}

@available(iOS 13.0, *)
extension FinnTextField {

    private static let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    private static let phoneRegex: String = "^(?:\\s*\\d){8,11}$"

    private var isValidInput: Bool {
        let isValid: Bool

        switch input {
        case .secure:
            isValid = isValidPassword(text)
        case .email:
            isValid = isValidEmail(text)
        case .phone:
            isValid = isValidPhoneNumber(text)
        default:
            isValid = true
        }

        if isValid, let validator = validator {
            return validator(text)
        }

        return isValid
    }

    private func evaluateTextState() {
        if !isValidInput {
            updateStyle(.error)
        } else {
            updateStyle(.default)
        }
    }

    private func evaluate(_ regEx: String, with string: String) -> Bool {
        let regExTest = NSPredicate(format: "SELF MATCHES %@", regEx)
        return regExTest.evaluate(with: string)
    }

    private func isValidEmail(_ emailAdress: String) -> Bool {
        return evaluate(FinnTextField.emailRegex, with: emailAdress)
    }

    private func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        return evaluate(FinnTextField.phoneRegex, with: phoneNumber)
    }

    private func isValidPassword(_ password: String) -> Bool {
        return !password.isEmpty
    }

}

// No `onEditingChanged` in SecureField, so need custom view
@available(iOS 13.0, *)
struct TextFieldComponent: UIViewRepresentable {

    let input: FinnTextField.Input
    let placeholder: String
    @Binding var text: String

    let onEditingChanged: (Bool) -> Void
    let onCommit: () -> Void

    func makeUIView(context: Context) -> UITextField {
        let field = UITextField()
        field.setContentHuggingPriority(.defaultHigh, for: .vertical)
        field.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        field.delegate = context.coordinator
        field.font = .body
        field.textColor = .textPrimary
        field.isSecureTextEntry = input == .secure
        field.keyboardType = input.keyboardType
        field.returnKeyType = input.returnKeyType
        field.textContentType = input.textContentType
        field.autocapitalizationType = input == .email ? .none : .sentences
        return field
    }

    func updateUIView(_ view: UITextField, context: Context) {
        view.text = text
        view.placeholder = placeholder
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {

        private let parent: TextFieldComponent

        init(_ parent: TextFieldComponent) {
            self.parent = parent
        }
        
        func textFieldDidBeginEditing(_ textField: UITextField) {
            parent.onEditingChanged(true)
        }

        func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
            parent.onEditingChanged(false)
            parent.onCommit()
        }

        func textFieldDidChangeSelection(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }

    }

}

@available(iOS 13.0, *)
// swiftlint:disable:next superfluous_disable_command type_name
struct FinnTextField_Previews: PreviewProvider {

    @State static var text: String = ""

    static var previews: some View {
        Group {
            FinnTextField(placeholder: "Default", text: $text)
            FinnTextField(input: .email, placeholder: "Email", helpText: "Help text", text: $text)
            FinnTextField(input: .secure, placeholder: "Secure", helpText: "Help text", text: $text)
            FinnTextField(input: .phone, placeholder: "Phone", text: $text)
            FinnTextField(input: .number, placeholder: "Number", text: $text)
        }
        .previewLayout(.sizeThatFits)
    }
}
