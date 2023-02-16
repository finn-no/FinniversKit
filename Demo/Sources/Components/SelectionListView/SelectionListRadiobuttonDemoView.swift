import UIKit
import FinniversKit

class SelectionListRadiobuttonDemoView: UIView, Tweakable {

    // MARK: - Internal properties

    lazy var tweakingOptions: [TweakingOption] = [
        .init(title: "3 items", action: { [weak self] in
            self?.checkmarkListView.configure(with: .create(number: 3))
        }),
        .init(title: "1 items", action: { [weak self] in
            self?.checkmarkListView.configure(with: .create(number: 1))
        }),
        .init(title: "2 items", action: { [weak self] in
            self?.checkmarkListView.configure(with: .create(number: 2))
        }),
        .init(title: "5 items", action: { [weak self] in
            self?.checkmarkListView.configure(with: .create(number: 5))
        }),
        .init(title: "3 items (title only)", action: { [weak self] in
            self?.checkmarkListView.configure(with: .createTitleOnly(number: 3))
        }),
    ]

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
        tweakingOptions.first?.action?()
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
