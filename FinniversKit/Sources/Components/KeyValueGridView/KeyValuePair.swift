public struct KeyValuePair: Hashable {
    let title: String
    let value: String
    let accessibilityLabel: String?

    public init(title: String, value: String, accessibilityLabel: String? = nil) {
        self.title = title
        self.value = value
        self.accessibilityLabel = accessibilityLabel
    }
}
