//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class ObjectPageTitleDemoView: UIView, Tweakable {

    private var titleView: ObjectPageTitleView?

    lazy var tweakingOptions: [TweakingOption] = {
        [
            TweakingOption(title: "Motor market", description: "Copyable labels") { [weak self] in
                self?.configureTitleView(title: "Mercedes-Benz C-Klasse", subtitle: "C200 4MATIC aut Hengerfeste, Panoramasoltak, AMG, LED +", areLabelsCopyable: true)
            },
            TweakingOption(title: "Motor market") { [weak self] in
                self?.configureTitleView(title: "Mercedes-Benz C-Klasse", subtitle: "C200 4MATIC aut Hengerfeste, Panoramasoltak, AMG, LED +")
            },
            TweakingOption(title: "Motor market w/ ribbon") { [weak self] in
                self?.configureTitleView(title: "Mercedes-Benz C-Klasse", subtitle: "C200 4MATIC aut Hengerfeste, Panoramasoltak, AMG, LED +", ribbonViewModel: .sold)
            },
            TweakingOption(title: "Torget w/ ribbon") { [weak self] in
                self?.configureTitleView(title: "Sofa med sjeselong - pris diskuterbar!", ribbonViewModel: .sold, spacingAfterTitle: .spacingS)
            },
            TweakingOption(title: "Torget giveaway") { [weak self] in
                self?.configureTitleView(title: "Sofa med sjeselong", subtitle: "Gis bort", subtitleStyle: .title3, spacingAfterTitle: .spacingS)
            },
            TweakingOption(title: "Realestate new construction market") { [weak self] in
                self?.configureTitleView(title: "Hareveien 11", titleStyle: .body, subtitle: "7 lekre selveierleiligheter uten gjenboere", subtitleStyle: .title2)
            },
            TweakingOption(title: "Realestate") { [weak self] in
                self?.configureTitleView(
                    title: "Oslomoen",
                    titleStyle: .body,
                    subtitle: "SOLGT! Nydelig selveierleilighet uten utsikt og innlagt vann",
                    subtitleStyle: .title3Strong,
                    caption: "Veigatestien 25B, 0101 Oslo",
                    captionStyle: .caption,
                    ribbonViewModel: .sold,
                    spacingAfterTitle: .spacingXS,
                    spacingAfterSubtitle: .spacingS
                )
            }
        ]
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        tweakingOptions.first?.action?()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    // MARK: - Private methods

    private func configureTitleView(
        title: String? = nil,
        titleStyle: Label.Style = .title2,
        subtitle: String? = nil,
        subtitleStyle: Label.Style = .body,
        caption: String? = nil,
        captionStyle: Label.Style = .caption,
        ribbonViewModel: RibbonViewModel? = nil,
        spacingAfterTitle: CGFloat = .spacingXS,
        spacingAfterSubtitle: CGFloat = .spacingXS,
        areLabelsCopyable: Bool = false
    ) {
        titleView?.removeFromSuperview()
        titleView = nil

        let newTitleView = ObjectPageTitleView(titleStyle: titleStyle, subtitleStyle: subtitleStyle, captionStyle: captionStyle, withAutoLayout: true)
        addSubview(newTitleView)

        NSLayoutConstraint.activate([
            newTitleView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
            newTitleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            newTitleView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        newTitleView.configure(
            withTitle: title,
            subtitle: subtitle,
            caption: caption,
            ribbonViewModel: ribbonViewModel,
            spacingAfterTitle: spacingAfterTitle,
            spacingAfterSubtitle: spacingAfterSubtitle
        )
        newTitleView.isTitleTextCopyable = areLabelsCopyable
        newTitleView.isSubtitleTextCopyable = areLabelsCopyable

        titleView = newTitleView
    }
}

// MARK: - Private extensions

private extension RibbonViewModel {
    static var sold = RibbonViewModel(style: .warning, title: "Solgt")
}
