import Foundation

public struct ViewingsListViewModel {

    let title: String
    let addToCalendarButtonTitle: String
    let viewings: [ViewingItemViewModel]
    let note: String?

    public init(title: String, addToCalendarButtonTitle: String, viewings: [ViewingItemViewModel] = [], note: String?) {
        self.title = title
        self.addToCalendarButtonTitle = addToCalendarButtonTitle
        self.viewings = viewings
        self.note = note
    }
}
