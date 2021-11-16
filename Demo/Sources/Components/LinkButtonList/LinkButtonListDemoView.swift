//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class LinkButtonListDemoView: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption] = [
        .init(title: "Misc. buttons", action: { [weak self] in
            self?.configure(viewModels: .defaults)
        }),
        .init(title: "Flat buttons", action: { [weak self] in
            self?.configure(viewModels: .alternateStyle)
        })
    ]

    private lazy var linkListView: LinkButtonListView = {
        let view = LinkButtonListView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        tweakingOptions.first?.action?()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setup() {
        addSubview(linkListView)
        NSLayoutConstraint.activate([
            linkListView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            linkListView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            linkListView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: - Private methods

    func configure(viewModels: [LinkButtonViewModel]) {
        linkListView.configure(with: viewModels)
    }
}

// MARK: - LinkButtonListViewDelegate

extension LinkButtonListDemoView: LinkButtonListViewDelegate {
    func linksListView(_ view: LinkButtonListView, didTapButtonWithIdentifier identifier: String?, url: URL) {
        print("✅ \(#function) - buttonIdentifier: \(identifier ?? "") - url: \(url)")
    }
}

// MARK: - Private extensions

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
            )
        ]
    }()

    static var alternateStyle: [LinkButtonViewModel] = {
        [
            LinkButtonViewModel(
                buttonIdentifier: "b1",
                buttonTitle: "Button 1",
                linkUrl: URL(string: "https://www.finn.no/")!,
                isExternal: false,
                buttonStyle: .flat,
                buttonSize: .normal
            ),
            LinkButtonViewModel(
                buttonIdentifier: "b2",
                buttonTitle: "Button 2",
                linkUrl: URL(string: "https://www.finn.no/")!,
                isExternal: false,
                buttonStyle: .flat,
                buttonSize: .normal
            ),
            LinkButtonViewModel(
                buttonIdentifier: "b3",
                buttonTitle: "Button 3",
                linkUrl: URL(string: "https://www.finn.no/")!,
                isExternal: false,
                buttonStyle: .flat,
                buttonSize: .normal
            ),
            LinkButtonViewModel(
                buttonIdentifier: "b4",
                buttonTitle: "Button 4",
                linkUrl: URL(string: "https://www.finn.no/")!,
                isExternal: false,
                buttonStyle: .flat,
                buttonSize: .normal
            )
        ]
    }()
}
