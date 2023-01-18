import Foundation

public class FrontPageSavedSearchesViewModel {
    let searchViewModels: [FrontPageSavedSearchViewModel]
    let title: String
    let buttonTitle: String

    var height: CGFloat {
        searchViewModels.isEmpty ? 0 : FrontPageSavedSearchesView.height
    }

    public init(searchViewModels: [FrontPageSavedSearchViewModel], title: String, buttonTitle: String) {
        self.searchViewModels = searchViewModels
        self.title = title
        self.buttonTitle = buttonTitle
    }
}
