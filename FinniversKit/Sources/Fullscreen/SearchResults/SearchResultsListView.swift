import Foundation

class SearchResultsListView: UIView {

    let title: String

    init(title: String) {
        self.title = title
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        fillInSuperview()
    }
}
