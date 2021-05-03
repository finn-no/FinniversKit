public struct TransactionEntryViewModel {
    public let title: String?
    public let text: String?
    public let imageUrl: String?
    public let showWarningIcon: Bool
    public let fallbackImage: UIImage
    public let accessibilityLabel: String

    public init(
        title: String?,
        text: String?,
        imageUrl: String?,
        showWarningIcon: Bool,
        fallbackImage: UIImage,
        accessibilityLabel: String
    ) {
        self.title = title
        self.text = text
        self.imageUrl = imageUrl
        self.showWarningIcon = showWarningIcon
        self.fallbackImage = fallbackImage
        self.accessibilityLabel = accessibilityLabel
    }
}
