import Foundation

public class FrontPageSavedSearchesViewModel {
    public let searchViewModels: [FrontPageSavedSearchViewModel]
    public let title: String
    public let buttonTitle: String

    public var height: CGFloat {
        searchViewModels.isEmpty ? 0 : FrontPageSavedSearchesView.height
    }

    public init(searchViewModels: [FrontPageSavedSearchViewModel], title: String, buttonTitle: String) {
        self.searchViewModels = searchViewModels
        self.title = title
        self.buttonTitle = buttonTitle
    }
}
