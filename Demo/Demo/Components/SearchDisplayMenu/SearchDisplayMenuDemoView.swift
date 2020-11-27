//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinnUI

class SearchDisplayMenuDemoView: UIView {
    private lazy var view: SearchDisplayMenuView = {
        let view = SearchDisplayMenuView(
            sortAccessibilityLabel: "Sorter",
            changeDisplayTypeAccessibilityLabel: "Endre visningstype",
            withAutoLayout: true
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
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
            view.centerYAnchor.constraint(equalTo: centerYAnchor),
            view.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}

// MARK: - SearchDisplayMenuViewDelegate

extension SearchDisplayMenuDemoView: SearchDisplayMenuViewDelegate {
    func searchDisplayMenuViewDidSelectSort() {
        print("Sort tapped!")
    }

    func searchDisplayMenuViewDidSelectChangeDisplayType() {
        print("Change display tapped!")
    }
}
