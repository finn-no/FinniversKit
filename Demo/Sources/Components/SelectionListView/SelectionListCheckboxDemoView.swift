import UIKit
import FinniversKit
import DemoKit

class SelectionListCheckboxDemoView: UIView {

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

extension SelectionListCheckboxDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case threeItems
        case oneItem
        case twoItems
        case fiveItems
        case threeItemsWithHtml
    }

    var dismissKind: DismissKind { .button }
    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .threeItems:
            checkmarkListView.configure(with: .create(number: 3, includeCheckmarkDetailsForLastItem: true))
        case .oneItem:
            checkmarkListView.configure(with: .create(number: 1))
        case .twoItems:
            checkmarkListView.configure(with: .create(number: 2))
        case .fiveItems:
            checkmarkListView.configure(with: .create(number: 5))
        case .threeItemsWithHtml:
            checkmarkListView.configure(with: .createWithHTML(number: 3))
        }
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
                icon: .fixedSize(UIImage(named: .favoriteActive).withRenderingMode(.alwaysTemplate)),
                detailItems: includeDetailItems ? Self.detailItems : nil,
                isInitiallySelected: $0 == 0
            )
        }
    }

    static func createWithHTML(number: Int) -> [SelectionItemModel] {
        (0..<number).map {
            let htmlString = "Kjøper betaler <del>80</del> <b><span style=\"color:tjt-price-highlight\">40 kr</span></b> for frakt."
            let spanMapper: HTMLStringUIKitStyleTranslator.SpanMapper = { attributes, currentStyle in
                for attribute in attributes {
                    guard attribute.name == "style",
                          attribute.value == "color:tjt-price-highlight" else {
                        return
                    }

                    currentStyle.foregroundColor = .dynamicColor(defaultColor: .red, darkModeColor: .yellow)
                }
            }
            let accessibilityString = "Kjøper betaler 40 kroner for frakt. Dette er en tilbudspris og koster 80 kroner til vanlig."
            return SelectionItemModel(
                identifier: "item-\($0)",
                title: "Helthjem",
                description: .html(
                    htmlString: htmlString,
                    spanMapper: spanMapper,
                    accessibilityString: accessibilityString),
                icon: .dynamic(UIImage(named: .torgetHelthjem)),
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
