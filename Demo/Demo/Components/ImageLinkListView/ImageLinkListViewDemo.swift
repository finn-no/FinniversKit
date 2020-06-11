import FinniversKit
import FinnUI

public class ImageLinkListViewDemo: UIView, Tweakable {

    lazy var tweakingOptions: [TweakingOption] = {
        [
            TweakingOption(title: "2 items, grouped horizontally") {
                self.imageLinkListView.configure(with: self.viewModels, groupAxis: .horizontal)
            },
            TweakingOption(title: "3 items, horizontally") {
                self.imageLinkListView.configure(with: self.viewModels + [.virtualViewing], groupAxis: .horizontal)
            },
            TweakingOption(title: "2 items, vertically") {
                self.imageLinkListView.configure(with: self.viewModels, groupAxis: .vertical)
            }
        ]
    }()

    // MARK: - Private properties

    private let viewModels: [ImageLinkViewModel] = [.videoLink, .virtualViewing]

    private lazy var imageLinkListView = ImageLinkListView(
        delegate: self,
        remoteImageViewDataSource: DemoRemoteImageViewDataSource.shared,
        withAutoLayout: true
    )

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
        addSubview(imageLinkListView)
        tweakingOptions.first?.action?()

        NSLayoutConstraint.activate([
            imageLinkListView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageLinkListView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            imageLinkListView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
        ])
    }
}

extension ImageLinkListViewDemo: ImageLinkViewDelegate {
    public func imageLinkViewWasSelected(_ view: ImageLinkView, url: String) {
        print("🔥🔥🔥🔥 ImageLinkView tapped with url: \(url)")
    }
}

// MARK: - Private extensions

private extension ImageLinkViewModel {
    static var videoLink = ImageLinkViewModel(
        description: "Videovisning",
        url: "https://www.finn.no",
        imageUrl: "https://i.pinimg.com/736x/73/de/32/73de32f9e5a0db66ec7805bb7cb3f807--navy-blue-houses-blue-and-white-houses-exterior.jpg",
        loadingColor: .salmon,
        overlayKind: .video
    )

    static var virtualViewing = ImageLinkViewModel(
        description: "360° visning",
        url: "https://www.finn.no",
        imageUrl: "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg",
        loadingColor: .mint,
        overlayKind: .virtualViewing
    )
}
