import UIKit
import FinniversKit

class SearchDemoView: UIView, Tweakable {

    // MARK: - Internal properties

    lazy var tweakingOptions: [TweakingOption] = [
        .init(title: "Demo items", action: { [weak self] in
            self?.searchView.configureSearchTextField(placeholder: "Placeholder", text: "Lorem ipsum ?")
            self?.searchView.configure(items: .demoItems)
        }),
        .init(title: "Empty search + results", action: { [weak self] in
            self?.searchView.configureSearchTextField(placeholder: "Placeholder", text: nil)
            self?.searchView.configure(items: [])
        }),
    ]

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
        tweakingOptions.first?.action?()
    }

    required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(searchView)
        searchView.fillInSuperview()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            self?.searchView.becomeFirstResponder()
        })
    }
}

// MARK: - SearchViewDelegate

extension SearchDemoView: SearchViewDelegate {
    func searchView(_ view: SearchView, didSelectItemAtIndex index: Int) {
        print("👉 Did select item at index \(index)")
    }

    func searchView(_ view: SearchView, didChangeSearchText searchText: String?) {
        print("🖋 Did change search text: '\(searchText)'")

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
