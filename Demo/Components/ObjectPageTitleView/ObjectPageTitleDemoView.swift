//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class ObjectPageTitleDemoView: UIView, Tweakable {

    private var titleView: ObjectPageTitleView?

    lazy var tweakingOptions: [TweakingOption] = {
        [
            TweakingOption(title: "Title and subtitle", description: "Default style") { [weak self] in
                self?.setupTitleView(title: "Mercedes-Benz C-Klasse", subtitle: "C200 4MATIC aut Hengerfeste, Panoramasoltak, AMG, LED +")
            },
            TweakingOption(title: "Only title", description: "Default style") { [weak self] in
                self?.setupTitleView(title: "Sofa med sjeselong - pris diskuterbar!")
            },
            TweakingOption(title: "Only subtitle", description: "Default style") { [weak self] in
                self?.setupTitleView(subtitle: "C200 4MATIC aut Hengerfeste, Panoramasoltak, AMG, LED +")
            },
        ]
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        tweakingOptions.first?.action?()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Private methods

    private func setupTitleView(
        title: String? = nil,
        subtitle: String? = nil,
        titleStyle: Label.Style = .title2,
        subtitleStyle: Label.Style = .body
    ) {
        titleView?.removeFromSuperview()
        titleView = nil

        let newTitleView = ObjectPageTitleView(titleStyle: titleStyle, subtitleStyle: subtitleStyle, withAutoLayout: true)
        addSubview(newTitleView)

        newTitleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing).isActive = true
        newTitleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing).isActive = true
        newTitleView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        newTitleView.configure(withTitle: title, subtitle: subtitle)
        self.titleView = newTitleView
    }
}
