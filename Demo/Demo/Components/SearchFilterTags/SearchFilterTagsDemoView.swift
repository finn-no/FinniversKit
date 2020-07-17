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

    private var searchFilterTags: [SearchFilterTagCellViewModel] = {
        return [
            SearchFilterTagCell(title: "'rålekker'", isValid: true),
            SearchFilterTagCell(title: "Oslo", isValid: true),
            SearchFilterTagCell(title: "70 - 40m²", isValid: false),
            SearchFilterTagCell(title: "Leilighet", isValid: true),
            SearchFilterTagCell(title: "Balkong/Terasse", isValid: true),
            SearchFilterTagCell(title: "Ikke 1. etasje", isValid: true)
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

        view.configure(with: searchFilterTags, reloadSection: false)
        view.reloadData()
    }
}

// MARK: - SearchFilterTagsViewDelegate

extension SearchFilterTagsDemoView: SearchFilterTagsViewDelegate {
    func searchFilterTagsViewDidSelectFilter(_ view: SearchFilterTagsView) {
        print("Present charcoal filter!")
    }

    func searchFilterTagsView(_ view: SearchFilterTagsView, didRemoveTagAt index: Int) {
        searchFilterTags.remove(at: index)
        view.configure(with: searchFilterTags)
    }
}

// MARK: - Demo data

private class SearchFilterTagCell: SearchFilterTagCellViewModel {
    let title: String
    let titleAccessibilityLabel: String
    let removeButtonAccessibilityLabel: String
    let isValid: Bool

    init(
        title: String,
        titleAccessibilityLabel: String = "",
        removeButtonAccessibilityLabel: String = "",
        isValid: Bool
    ) {
        self.title = title
        self.titleAccessibilityLabel = titleAccessibilityLabel
        self.removeButtonAccessibilityLabel = removeButtonAccessibilityLabel
        self.isValid = isValid
    }
}
