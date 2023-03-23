import Foundation

public struct ViewingItemViewModel {

    let weekday: String?
    let month: String?
    let day: String?
    let timeInterval: String?
    let note: String?

    public init(weekday: String?, month: String?, day: String?, timeInterval: String?, note: String?) {
        self.weekday = weekday
        self.month = month
        self.day = day
        self.timeInterval = timeInterval
        self.note = note
    }
}
