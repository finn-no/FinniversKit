//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

public enum NotificationCenterSearchGroupOption: String, CaseIterable {
    case byDay
    case bySearch
    case flat

    var icon: UIImage {
        switch self {
        case .byDay: return UIImage(named: .favoritesSortLastAdded)
        case .bySearch: return UIImage(named: .magnifyingGlass)
        case .flat: return UIImage(named: .clock)
        }
    }
}

public struct NotificationGroupOptionsViewModel {
    let bySearchTitle: String?
    let byDayTitle: String?
    let flatTitle: String?

    public init(bySearchTitle: String?, byDayTitle: String?, flatTitle: String?) {
        self.bySearchTitle = bySearchTitle
        self.byDayTitle = byDayTitle
        self.flatTitle = flatTitle
    }
}

public protocol NotificationGroupOptionsViewDelegate: AnyObject {
    func notificationGroupOptionsView(_ view: NotificationGroupOptionsView, didSelect option: NotificationCenterSearchGroupOption)
}

public class NotificationGroupOptionsView: UIView {
    let viewModel: NotificationGroupOptionsViewModel

    public weak var delegate: NotificationGroupOptionsViewDelegate?

    private let selectedOption: NotificationCenterSearchGroupOption

    public init(viewModel: NotificationGroupOptionsViewModel, selectedOption: NotificationCenterSearchGroupOption) {
        self.viewModel = viewModel
        self.selectedOption = selectedOption
        super.init(frame: .zero)
        setup()
    }

    public required init?(coder: NSCoder) {
        fatalError("not implemented")
    }

    private lazy var optionsView: SelectionView = {
        var sortOptions: [SortOption] = [
            viewModel.byDayTitle.map { SortOption(groupOption: .byDay, title: $0) },
            viewModel.bySearchTitle.map { SortOption(groupOption: .bySearch, title: $0) },
            viewModel.flatTitle.map { SortOption(groupOption: .flat, title: $0) },
        ].compactMap({ $0 })

        let view = SelectionView(
            options: sortOptions,
            selectedOptionIdentifier: selectedOption.rawValue
        )
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()

    private func setup() {
        addSubview(optionsView)
        optionsView.fillInSuperview()
    }
}

// MARK: - Sort Option nested model
private extension NotificationGroupOptionsView {
    struct SortOption: SelectionOptionModel {
        let groupOption: NotificationCenterSearchGroupOption
        let title: String

        var identifier: String { groupOption.rawValue }
        var icon: UIImage { groupOption.icon }

        init(groupOption: NotificationCenterSearchGroupOption, title: String) {
            self.groupOption = groupOption
            self.title = title
        }
    }
}

// MARK: - SelectionViewDelegate
extension NotificationGroupOptionsView: SelectionViewDelegate {
    public func selectionView(_ view: SelectionView, didSelectOptionWithIdentifier selectedIdentifier: String) {
        guard let option = NotificationCenterSearchGroupOption(rawValue: selectedIdentifier) else { return }
        delegate?.notificationGroupOptionsView(self, didSelect: option)
    }
}
