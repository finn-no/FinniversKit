//
//  Copyright © 2021 FINN AS. All rights reserved.
//

import SwiftUI

@available(iOS 13.0, *)
public struct FinnTextView: View {

    let placeholderText: String
    @Binding var text: String

    public init(placeholder: String = "", text: Binding<String>) {
        self.placeholderText = placeholder
        self._text = text
    }

    public var body: some View {
        TextViewComponent(text: $text)
            .overlay(placeholder, alignment: .topLeading)
            .overlay(underline, alignment: .bottom)
    }

    @ViewBuilder
    private var placeholder: some View {
        if text.isEmpty {
            Text(placeholderText)
                .foregroundColor(Color.textDisabled)
                .finnFont(.body)
                .padding(.vertical, .spacingS)
                .padding(.leading, .spacingS + 5) // UITextView.textContainerInset.left + 5 to align with caret
                .padding(.trailing, .spacingS)
        }
    }

    private var underline: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundColor(Color.accentSecondaryBlue)
    }

}

@available(iOS 13.0, *)
struct TextViewComponent: UIViewRepresentable {

    @Binding var text: String

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView()
        view.delegate = context.coordinator
        view.font = .body
        view.textColor = .textPrimary
        view.backgroundColor = .bgSecondary
        view.textContainerInset = UIEdgeInsets(top: .spacingS, left: .spacingS, bottom: .spacingS, right: .spacingS)
        view.isScrollEnabled = false
        return view
    }

    func updateUIView(_ view: UITextView, context: Context) {
        view.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextViewDelegate {

        private let parent: TextViewComponent

        init(_ parent: TextViewComponent) {
            self.parent = parent
        }

        func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
            textView.inputAccessoryView = toolbar
            return true
        }

        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text ?? ""
        }

        private lazy var toolbar: UIToolbar = {
            let toolBar = UIToolbar(frame: .init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 100)) // Some height to work with to avoid usatisfiable constraints
            toolBar.barStyle = .default
            toolBar.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            toolBar.backgroundColor = .systemBackground
            toolBar.isTranslucent = true
            toolBar.items = [
                UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
                UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePicker))
            ]
            return toolBar
        }()

        @objc func donePicker() {
          UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }

    }

}

@available(iOS 13.0, *)
// swiftlint:disable:next superfluous_disable_command type_name
struct FinnTextView_Previews: PreviewProvider {

    @State static var text: String = ""

    static var previews: some View {
        VStack(spacing: 16) {
            FinnTextView(text: $text).frame(height: 100)
            FinnTextView(placeholder: "Placeholder", text: $text).frame(height: 100)
        }
        .previewLayout(.sizeThatFits)
    }
}
