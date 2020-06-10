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
            view.remoteImageViewDataSource = self
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

// MARK: - RemoteImageTableViewCellDataSource

extension ImageLinkViewDemo: RemoteImageViewDataSource {
    public func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

        // Demo code only.
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            usleep(50_000)
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }

        task.resume()
    }

    public func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}

    public func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        nil
    }
}

extension ImageLinkViewModel {
    static var videoLink = ImageLinkViewModel(
        description: "Videovisning",
        imageUrl: "https://i.pinimg.com/736x/73/de/32/73de32f9e5a0db66ec7805bb7cb3f807--navy-blue-houses-blue-and-white-houses-exterior.jpg",
        loadingColor: .salmon,
        overlayKind: .video
    )

    static var virtualViewing = ImageLinkViewModel(
        description: "360° visning",
        imageUrl: "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg",
        loadingColor: .mint,
        overlayKind: .virtualViewing
    )
}
