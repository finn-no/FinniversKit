import Foundation

class SearchResultsListView: UIView {

    let title: String

    init(title: String) {
        self.title = title
        super.init(frame: .zero)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
