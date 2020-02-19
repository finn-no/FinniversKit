//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class ObjectPageTitleDemoView: UIView, Tweakable {

    private lazy var titleView = ObjectPageTitleView(withAutoLayout: true)

    lazy var tweakingOptions: [TweakingOption] = {
        [
            TweakingOption(title: "Title and subtitle", description: "Default style") { [weak self] in
                self?.configureTitleView(title: "Mercedes-Benz C-Klasse", subtitle: "C200 4MATIC aut Hengerfeste, Panoramasoltak, AMG, LED +")
            },
            TweakingOption(title: "Only title", description: "Default style") { [weak self] in
                self?.configureTitleView(title: "Sofa med sjeselong - pris diskuterbar!")
            },
            TweakingOption(title: "Only subtitle", description: "Default style") { [weak self] in
                self?.configureTitleView(subtitle: "C200 4MATIC aut Hengerfeste, Panoramasoltak, AMG, LED +")
            },
        ]
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        tweakingOptions.first?.action?()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Private methods

    private func setup() {
        addSubview(titleView)

        NSLayoutConstraint.activate([
            titleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            titleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
            titleView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    private func configureTitleView(
        title: String? = nil,
        subtitle: String? = nil
    ) {
        titleView.configure(withTitle: title, subtitle: subtitle)
    }
}
