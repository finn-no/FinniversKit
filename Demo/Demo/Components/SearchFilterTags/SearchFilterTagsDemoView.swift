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
            SearchFilterTagCellViewModel(title: "'rålekker'", isValid: true),
            SearchFilterTagCellViewModel(title: "Oslo", isValid: true),
            SearchFilterTagCellViewModel(title: "70 - 40m²", isValid: false),
            SearchFilterTagCellViewModel(title: "Leilighet", isValid: true),
            SearchFilterTagCellViewModel(title: "Balkong/Terasse", isValid: true),
            SearchFilterTagCellViewModel(title: "Ikke 1. etasje", isValid: true)
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
            view.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        view.configure(with: searchFilterTags, reloadSection: false)
        view.reloadData()
    }
}

// MARK: - SearchFilterTagsViewDelegate

extension SearchFilterTagsDemoView: SearchFilterTagsViewDelegate {
    func searchFilterTagsViewDidSelectFilter(_ view: SearchFilterTagsView) {
        print("Present filter!")
    }

    func searchFilterTagsView(_ view: SearchFilterTagsView, didRemoveTagAt index: Int) {
        searchFilterTags.remove(at: index)
        view.configure(with: searchFilterTags)
    }

    func searchFilterTagsView(_ view: SearchFilterTagsView, didTapSearchFilterTagAt index: Int) {
        print("Tapped filter tag with index \(index)")
    }
}

// MARK: - Demo data

private extension SearchFilterTagCellViewModel {
    init(title: String, isValid: Bool) {
        self.init(
            title: title,
            titleAccessibilityLabel: "",
            removeButtonAccessibilityLabel: "",
            isValid: isValid
        )
    }
}
