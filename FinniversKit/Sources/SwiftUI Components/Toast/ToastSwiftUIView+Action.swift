import Foundation

extension ToastSwiftUIView {
    public struct Action {
        public let title: String
        public let buttonStyle: ButtonStyle
        public let action: (() -> Void)

        public init(
            title: String,
            buttonStyle: ButtonStyle = .normal,
            action: @escaping (() -> Void)
        ) {
            self.title = title
            self.buttonStyle = buttonStyle
            self.action = action
        }
    }
}
