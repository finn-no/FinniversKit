import Foundation

public struct ViewingsRedesignViewModel {
    public let title: String
    public let viewings: [ViewingItemViewModel]
    public let moreInfoText: String?
    public let prospectusButton: Button?
    public let viewingSignupButton: Button?
    public let addToCalendarButtonTitle: String

    public init(
        title: String,
        viewings: [ViewingItemViewModel],
        moreInfoText: String? = nil,
        prospectusButton: ViewingsRedesignViewModel.Button? = nil,
        viewingSignupButton: ViewingsRedesignViewModel.Button? = nil,
        addToCalendarButtonTitle: String
    ) {
        self.title = title
        self.viewings = viewings
        self.moreInfoText = moreInfoText
        self.prospectusButton = prospectusButton
        self.viewingSignupButton = viewingSignupButton
        self.addToCalendarButtonTitle = addToCalendarButtonTitle
    }
}

extension ViewingsRedesignViewModel {
    public struct Button {
        public let title: String
        public let description: String?
        public let url: String

        public init(title: String, description: String? = nil, url: String) {
            self.title = title
            self.description = description
            self.url = url
        }
    }
}
