//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

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
        configure(forTweakAt: 0)
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
}

extension LinkButtonListDemoView: TweakableDemo {
    enum Tweaks: String, CaseIterable, TweakingOption {
        case miscButtons
        case flatButtons
    }

    var numberOfTweaks: Int { Tweaks.allCases.count }

    func tweak(for index: Int) -> any TweakingOption {
        Tweaks.allCases[index]
    }

    func configure(forTweakAt index: Int) {
        switch Tweaks.allCases[index] {
        case .miscButtons:
            linkListView.configure(with: .defaults)
        case .flatButtons:
            linkListView.configure(with: .alternateStyle)
        }
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
                linkUrl: URL(string: "https://www.finn.no/")!, // swiftlint:disable:this force_unwrapping
                isExternal: true
            ),
            LinkButtonViewModel(
                buttonIdentifier: "loan",
                buttonTitle: "External link w/ subtitle",
                subtitle: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor.",
                linkUrl: URL(string: "https://www.finn.no/")!, // swiftlint:disable:this force_unwrapping
                isExternal: true
            ),
            LinkButtonViewModel(
                buttonIdentifier: "loan",
                buttonTitle: "External link w/ overridden icon color",
                linkUrl: URL(string: "https://www.finn.no/")!, // swiftlint:disable:this force_unwrapping
                isExternal: true,
                externalIconColor: .red
            ),
            LinkButtonViewModel(
                buttonIdentifier: "insurance",
                buttonTitle: "In-app link",
                linkUrl: URL(string: "https://www.finn.no/")!, // swiftlint:disable:this force_unwrapping
                isExternal: false
            ),
            LinkButtonViewModel(
                buttonIdentifier: "insurance",
                buttonTitle: "In-app link w/subtitle",
                subtitle: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor.",
                linkUrl: URL(string: "https://www.finn.no/")!, // swiftlint:disable:this force_unwrapping
                isExternal: false
            )
        ]
    }()

    static var alternateStyle: [LinkButtonViewModel] = {
        [
            LinkButtonViewModel(
                buttonIdentifier: "b1",
                buttonTitle: "Button 1",
                linkUrl: URL(string: "https://www.finn.no/")!, // swiftlint:disable:this force_unwrapping
                isExternal: false,
                buttonStyle: .flat,
                buttonSize: .normal
            ),
            LinkButtonViewModel(
                buttonIdentifier: "b2",
                buttonTitle: "Button 2",
                linkUrl: URL(string: "https://www.finn.no/")!, // swiftlint:disable:this force_unwrapping
                isExternal: false,
                buttonStyle: .flat,
                buttonSize: .normal
            ),
            LinkButtonViewModel(
                buttonIdentifier: "b3",
                buttonTitle: "Button 3",
                linkUrl: URL(string: "https://www.finn.no/")!, // swiftlint:disable:this force_unwrapping
                isExternal: false,
                buttonStyle: .flat,
                buttonSize: .normal
            ),
            LinkButtonViewModel(
                buttonIdentifier: "b4",
                buttonTitle: "Button 4",
                linkUrl: URL(string: "https://www.finn.no/")!, // swiftlint:disable:this force_unwrapping
                isExternal: false,
                buttonStyle: .flat,
                buttonSize: .normal
            )
        ]
    }()
}
