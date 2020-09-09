import FinnUI
import FinniversKit

public class IconLinkListViewDemo: UIView, Tweakable {
    lazy var tweakingOptions: [TweakingOption] = {
        [
            TweakingOption(title: "2 items") {
                self.iconLinkListView.configure(with: [.videoLink, .virtualViewing])
            },
            TweakingOption(title: "3 items") {
                self.iconLinkListView.configure(with: [.videoLink, .virtualViewing, .virtualViewing])
            },
            TweakingOption(title: "Single item") {
                self.iconLinkListView.configure(with: [.carPresentation])
            }
        ]
    }()

    // MARK: - Private properties

    private lazy var iconLinkListView = IconLinkListView(delegate: self, withAutoLayout: true)

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(iconLinkListView)
        tweakingOptions.first?.action?()

        NSLayoutConstraint.activate([
            iconLinkListView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconLinkListView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            iconLinkListView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
        ])
    }
}

extension IconLinkListViewDemo: IconLinkViewDelegate {
    public func iconLinkViewWasSelected(_ view: IconLinkView, url: String, identifier: String?) {
        print("🔥🔥🔥🔥 IconLinkView tapped with url: \(url), identifier: \(identifier ?? "")")
    }
}

// MARK: - Private extensions

private extension IconLinkViewModel {
    static var videoLink = IconLinkViewModel(
        icon: UIImage(named: .playVideo),
        title: "Videovisning",
        url: "https://www.finn.no",
        identifier: "video"
    )

    static var virtualViewing = IconLinkViewModel(
        icon: UIImage(named: .virtualViewing),
        title: "360° visning",
        url: "https://www.finn.no",
        identifier: "virtual-viewing"
    )

    static var carPresentation = IconLinkViewModel(
        icon: UIImage(named: .playVideo),
        title: "Se videopresentasjon av bilen",
        url: "https://www.finn.no",
        identifier: "video"
    )
}
