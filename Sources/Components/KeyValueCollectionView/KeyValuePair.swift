public struct KeyValuePair: Hashable {
    let title: String
    let value: String

    public init(title: String, value: String) {
        self.title = title
        self.value = value
    }
}
