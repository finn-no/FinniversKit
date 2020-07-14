//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinnUI

class SearchFilterTagsDemoView: UIView {
    private lazy var view: SearchFilterTagsView = {
        let view = SearchFilterTagsView(viewModel: SearchFilterTagsData())
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    var searchFilterTags: [SearchFilterTagCellViewModel] = {
        return [
            SearchFilterTagCell(title: "'rålekker'", accessibilityLabel: "", isValid: true),
            SearchFilterTagCell(title: "Oslo", accessibilityLabel: "", isValid: true),
            SearchFilterTagCell(title: "70 - 40m²", accessibilityLabel: "", isValid: false),
            SearchFilterTagCell(title: "Leilighet", accessibilityLabel: "", isValid: true),
            SearchFilterTagCell(title: "Balkong/Terasse", accessibilityLabel: "", isValid: true),
            SearchFilterTagCell(title: "Ikke 1. etasje", accessibilityLabel: "", isValid: true)
        ]
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(view)

        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.centerYAnchor.constraint(equalTo: centerYAnchor),
            view.heightAnchor.constraint(equalToConstant: 50)
        ])

        view.configure(with: searchFilterTags)
    }
}

extension SearchFilterTagsDemoView: SearchFilterTagsViewDelegate {
    func searchFilterTagsViewDidSelectFilter(_ view: SearchFilterTagsView) {
        print("Present charcoal filter!")
    }

    func searchFilterTagsView(_ view: SearchFilterTagsView, didRemoveTagAt index: Int) {
        searchFilterTags.remove(at: index)
        view.configure(with: searchFilterTags)
    }
}

private class SearchFilterTagCell: SearchFilterTagCellViewModel {
    let title: String
    let accessibilityLabel: String
    let isValid: Bool

    init(title: String, accessibilityLabel: String, isValid: Bool) {
        self.title = title
        self.accessibilityLabel = accessibilityLabel
        self.isValid = isValid
    }
}
