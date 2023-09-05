import UIKit
import FinniversKit
import DemoKit

class SearchDemoView: UIView {

    // MARK: - Private properties

    private lazy var searchView: SearchView = {
        let view = SearchView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configure(forTweakAt: 0)
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(searchView)
        searchView.fillInSuperview()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            _ = self?.searchView.becomeFirstResponder()
        })
    }
}

extension SearchDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case demoItems
        case emptySearchAndResults
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .demoItems:
            searchView.configureSearchTextField(placeholder: "Placeholder", text: "Lorem ipsum ?")
            searchView.configure(items: .demoItems)
        case .emptySearchAndResults:
            searchView.configureSearchTextField(placeholder: "Placeholder", text: nil)
            searchView.configure(items: [])
        }
    }
}

// MARK: - SearchViewDelegate

extension SearchDemoView: SearchViewDelegate {
    func searchView(_ view: SearchView, didSelectItemAtIndex index: Int) {
        print("👉 Did select item at index \(index)")
    }

    func searchView(_ view: SearchView, didChangeSearchText searchText: String?) {
        print("🖋 Did change search text: '\(searchText ?? "")'")

        if let searchText = searchText, !searchText.isEmpty {
            let items = (1...searchText.count).map { "\($0) \(searchText)" }
            searchView.configure(items: items)
        } else {
            searchView.configure(items: [])
        }
    }
}

// MARK: - Private extensions

private extension Array where Element == String {
    static var demoItems: [String] {
        [
            "Lorem ipsum dolor sit amet",
            "Consectetur adipiscing elit",
            "Sed do eiusmod tempor",
            "Incididunt ut labore et dolore",
            "Magna aliqua",
            "Pulvinar sapien et ligula",
            "Ullamcorper malesuada proin",
            "Libero",
            "Tempor id eu nisl nunc mi ipsum faucibus",
            "Ultricies mi eget mauris pharetra et ultrices neque ornare aenean",
        ]
    }
}
