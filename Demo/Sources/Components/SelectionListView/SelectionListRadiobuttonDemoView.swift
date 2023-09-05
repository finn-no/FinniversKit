import UIKit
import FinniversKit
import DemoKit

class SelectionListRadiobuttonDemoView: UIView {

    // MARK: - Private properties

    private lazy var checkmarkListView: SelectionListView = {
        let view = SelectionListView(presentation: .radioButtons, withAutoLayout: true)
        view.delegate = self
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configure(forTweakAt: 0)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(checkmarkListView)

        NSLayoutConstraint.activate([
            checkmarkListView.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            checkmarkListView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            checkmarkListView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM)
        ])
    }
}

extension SelectionListRadiobuttonDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case threeItems
        case oneItem
        case twoItems
        case fiveItems
        case threeItemsWithTitleOnly
    }

    var dismissKind: DismissKind { .button }
    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .threeItems:
            checkmarkListView.configure(with: .create(number: 3))
        case .oneItem:
            checkmarkListView.configure(with: .create(number: 1))
        case .twoItems:
            checkmarkListView.configure(with: .create(number: 2))
        case .fiveItems:
            checkmarkListView.configure(with: .create(number: 5))
        case .threeItemsWithTitleOnly:
            checkmarkListView.configure(with: .createTitleOnly(number: 3))
        }
    }
}

// MARK: - SelectionListViewDelegate

extension SelectionListRadiobuttonDemoView: SelectionListViewDelegate {
    func selectionListView(_ view: SelectionListView, didToggleItemAtIndex index: Int, withIdentifier identifier: String?, isSelected: Bool) {
        print("👉 Did toggle item at index \(index) with identifier '\(identifier ?? "")'. Is selected: \(isSelected)")
    }
}

// MARK: - Private extensions

private extension Array where Element == SelectionItemModel {
    static func create(number: Int) -> [SelectionItemModel] {
        (0..<number).map {
            SelectionItemModel(
                identifier: "item-\($0)",
                title: "Jeg kan overlevere ved oppmøte",
                description: .plain("Du og kjøper gjør en egen avtale"),
                icon: .fixedSize(UIImage(named: .favoriteActive).withRenderingMode(.alwaysTemplate)),
                isInitiallySelected: $0 == 0
            )
        }
    }

    static func createTitleOnly(number: Int) -> [SelectionItemModel] {
        (0..<number).map {
            SelectionItemModel(
                identifier: "item-\($0)",
                title: "Jeg kan overlevere ved oppmøte",
                description: .none,
                icon: .none,
                isInitiallySelected: $0 == 0
            )
        }
    }
}
