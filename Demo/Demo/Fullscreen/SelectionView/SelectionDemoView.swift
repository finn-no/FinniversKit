//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

final class SelectionDemoView: UIView {
    private(set) lazy var view: SelectionView = {
        let view = SelectionView(dataSource: self, selectedIndex: 0)
        view.delegate = self
        return view
    }()

    let options = [
        OptionCellViewModel(title: "Sist lagt til", icon: UIImage(named: .favoritesSortLastAdded)),
        OptionCellViewModel(title: "Annonsestatus", icon: UIImage(named: .favoritesSortAdStatus)),
        OptionCellViewModel(title: "Sist oppdatert av selger", icon: UIImage(named: .republish)),
        OptionCellViewModel(title: "Nærmest meg", icon: UIImage(named: .favoritesSortDistance))
    ]

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(view)
        view.fillInSuperview()
    }
}

// MARK: - SelectionViewDelegate

extension SelectionDemoView: SelectionViewDelegate {
    func selectionView(_ view: SelectionView, didSelectOptionAtIndex index: Int) {
        print("\(options[index].title) selected")
    }
}

extension SelectionDemoView: SelectionViewDataSource {
    func selectionView(_ view: SelectionView, viewModelForOptionAt index: Int) -> OptionCellViewModel {
        options[index]
    }

    func numberOfOptions(inSelectionView: SelectionView) -> Int {
        options.count
    }
}
