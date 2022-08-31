import UIKit
import FinniversKit

class SelectionListCheckboxDemoView: UIView, Tweakable {

    // MARK: - Internal properties

    lazy var tweakingOptions: [TweakingOption] = [
        .init(title: "3 items", action: { [weak self] in
            self?.checkmarkListView.configure(with: .create(number: 3, includeCheckmarkDetailsForLastItem: true))
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
        .init(title: "3 items with HTML", action: { [weak self] in
            self?.checkmarkListView.configure(with: .createWithHTML(number: 3))
        }),
    ]

    // MARK: - Private properties

    private lazy var checkmarkListView: SelectionListView = {
        let view = SelectionListView(presentation: .checkboxes, withAutoLayout: true)
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

extension SelectionListCheckboxDemoView: SelectionListViewDelegate {
    func selectionListView(_ view: SelectionListView, didToggleItemAtIndex index: Int, withIdentifier identifier: String?, isSelected: Bool) {
        print("👉 Did toggle item at index \(index) with identifier '\(identifier ?? "")'. Is selected: \(isSelected)")
    }
}

// MARK: - Private extensions

private extension Array where Element == SelectionItemModel {
    static func create(number: Int, includeCheckmarkDetailsForLastItem: Bool = false) -> [SelectionItemModel] {
        (0..<number).map {
            let includeDetailItems = ($0 == number - 1) && includeCheckmarkDetailsForLastItem
            return SelectionItemModel(
                identifier: "item-\($0)",
                title: "Jeg kan overlevere ved oppmøte",
                description: .plain("Du og kjøper gjør en egen avtale"),
                icon: UIImage(named: .favoriteActive).withRenderingMode(.alwaysTemplate),
                detailItems: includeDetailItems ? Self.detailItems : nil,
                isInitiallySelected: $0 == 0
            )
        }
    }

    static func createWithHTML(number: Int) -> [SelectionItemModel] {
        (0..<number).map {
            let htmlString = "Kjøper betaler <del>80</del> <b><span style=\"color:tjt-price-highlight\">40 kr</span></b> for frakt."
            let style: [String: String] = [
                "tjt-price-highlight": UIColor.red.hexString
            ]
            let accessibilityString = "Kjøper betaler 40 kroner for frakt. Dette er en tilbudspris og koster 80 kroner til vanlig."
            return SelectionItemModel(
                identifier: "item-\($0)",
                title: "Jeg kan overlevere ved oppmøte",
                description: .html(
                    htmlString: htmlString,
                    style: style,
                    accessibilityString: accessibilityString),
                icon: UIImage(named: .favoriteActive).withRenderingMode(.alwaysTemplate),
                isInitiallySelected: true
            )
        }
    }

    private static var detailItems: [String] {
        [
            "Officia at quas",
            "Odit cumque et quisquam id ut nesciunt suscipit beatae enim",
            "Minus corrupti molestiae ad"
        ]
    }
}
