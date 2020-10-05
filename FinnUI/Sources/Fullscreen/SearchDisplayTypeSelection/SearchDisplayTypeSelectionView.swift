//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public protocol SearchDisplayTypeSelectionViewDelegate: AnyObject {
    func searchDisplayTypeSelectionView(_ view: SearchDisplayTypeSelectionView, didSelectOption option: SearchDisplayTypeOption)
}

public final class SearchDisplayTypeSelectionView: UIView {

    // MARK: - Public properties

    public var totalHeight: CGFloat {
        SelectionView.rowHeight * CGFloat(displayTypeOptions.count)
    }

    public weak var delegate: SearchDisplayTypeSelectionViewDelegate?

    // MARK: - Private properties

    private let displayTypeOptions: [SearchDisplayTypeOptionModel]
    private var selectedDisplayTypeOption: SearchDisplayTypeOption

    private lazy var selectionView: SelectionView = {
        let view = SelectionView(options: displayTypeOptions, selectedOptionIdentifier: selectedDisplayTypeOption.rawValue)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    // MARK: - Init

    public init(
        viewModel: SearchDisplayTypeSelectionViewModel,
        selectedDisplayTypeOption: SearchDisplayTypeOption,
        supportedDisplayTypeOptions: [SearchDisplayTypeOption]
    ) {
        self.displayTypeOptions = supportedDisplayTypeOptions.map({ viewModel.model(for: $0) })
        self.selectedDisplayTypeOption = selectedDisplayTypeOption
        super.init(frame: .zero)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(selectionView)
        selectionView.fillInSuperview()
    }
}

// MARK: - SelectionViewDelegate

extension SearchDisplayTypeSelectionView: SelectionViewDelegate {
    public func selectionView(_ view: SelectionView, didSelectOptionWithIdentifier selectedIdentifier: String) {
        guard let displayTypeOption = SearchDisplayTypeOption(rawValue: selectedIdentifier) else { return }
        delegate?.searchDisplayTypeSelectionView(self, didSelectOption: displayTypeOption)
    }
}

// MARK: - Private extensions / types

private extension SearchDisplayTypeSelectionViewModel {
    func model(for option: SearchDisplayTypeOption) -> SearchDisplayTypeOptionModel {
        switch option {
        case .list:
            return SearchDisplayTypeOptionModel(title: listText, icon: listIcon, searchDisplayTypeOption: .list)
        case .grid:
            return SearchDisplayTypeOptionModel(title: gridText, icon: gridIcon, searchDisplayTypeOption: .grid)
        case .map:
            return SearchDisplayTypeOptionModel(title: mapText, icon: mapIcon, searchDisplayTypeOption: .map)
        }
    }
}

private struct SearchDisplayTypeOptionModel: SelectionOptionModel {
    let title: String
    let icon: UIImage
    let searchDisplayTypeOption: SearchDisplayTypeOption
    var identifier: String { searchDisplayTypeOption.rawValue }

    init(title: String, icon: UIImage, searchDisplayTypeOption: SearchDisplayTypeOption) {
        self.title = title
        self.icon = icon
        self.searchDisplayTypeOption = searchDisplayTypeOption
    }
}
