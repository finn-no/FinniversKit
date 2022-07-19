import Foundation

public enum AddressComponentKind {
    case regular(Model)
    case postalCodeAndPlace(postalCode: Model, postalPlace: Model)

    public struct Model {
        public let value: String?
        public let placeholder: String
        public let noValueAccessibilityLabel: String?

        public init(value: String?, placeholder: String, noValueAccessibilityLabel: String? = nil) {
            self.value = value
            self.placeholder = placeholder
            self.noValueAccessibilityLabel = noValueAccessibilityLabel
        }
    }
}
