import FinniversKit
import FinnUI

public class ImageLinkViewDemo: UIView {

    // MARK: - Private properties

    private let viewModels: [ImageLinkViewModel] = [.videoLink, .virtualViewing]

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.spacing = .spacingM
        stackView.axis = .vertical
        return stackView
    }()

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
        let views = viewModels.map { viewModel -> ImageLinkView in
            let view = ImageLinkView(withAutoLayout: true)
            view.remoteImageViewDataSource = DemoRemoteImageViewDataSource.shared
            view.delegate = self
            view.configure(with: viewModel)
            return view
        }

        addSubview(stackView)
        stackView.addArrangedSubviews(views)

        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
        ])
    }
}

extension ImageLinkViewDemo: ImageLinkViewDelegate {
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
