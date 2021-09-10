public struct HelthjemViewModel {
    let title: String
    let detail: String
    let primaryButtonTitle: String
    let secondaryButtonTitle: String?

    public init(
        title: String,
        detail: String,
        primaryButtonTitle: String,
        secondaryButtonTitle: String? = nil
    ) {
        self.title = title
        self.detail = detail
        self.primaryButtonTitle = primaryButtonTitle
        self.secondaryButtonTitle = secondaryButtonTitle
    }
}
