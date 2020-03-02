//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class LinkButtonListDemoView: UIView {
    private lazy var linkListView: LinkButtonListView = {
        let view = LinkButtonListView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        linkListView.configure(with: .defaults)

        addSubview(linkListView)
        NSLayoutConstraint.activate([
            linkListView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            linkListView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            linkListView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

extension LinkButtonListDemoView: LinkButtonListViewDelegate {
    func linksListView(_ view: LinkButtonListView, didTapButtonWithIdentifier identifier: String?, url: URL) {
        print("🔥🔥🔥🔥 \(#function) - buttonIdentifier: \(identifier ?? "") - url: \(url)")
    }
}

private extension Array where Element == LinkButtonViewModel {
    static var `defaults`: [LinkButtonViewModel] = {
        [
            LinkButtonViewModel(
                buttonIdentifier: "loan",
                buttonTitle: "External link",
                linkUrl: URL(string: "https://www.finn.no/")!,
                isExternal: true
            ),
            LinkButtonViewModel(
                buttonIdentifier: "loan",
                buttonTitle: "External link w/ subtitle",
                subtitle: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor.",
                linkUrl: URL(string: "https://www.finn.no/")!,
                isExternal: true
            ),
            LinkButtonViewModel(
                buttonIdentifier: "insurance",
                buttonTitle: "In-app link",
                linkUrl: URL(string: "https://www.finn.no/")!,
                isExternal: false
            ),
            LinkButtonViewModel(
                buttonIdentifier: "insurance",
                buttonTitle: "In-app link w/subtitle",
                subtitle: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor.",
                linkUrl: URL(string: "https://www.finn.no/")!,
                isExternal: false
            ),
        ]
    }()
}
