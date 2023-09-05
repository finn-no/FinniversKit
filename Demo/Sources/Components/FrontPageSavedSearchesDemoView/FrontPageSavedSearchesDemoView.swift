import FinniversKit
import DemoKit

class FrontPageSavedSearchesDemoView: UIView, Demoable {
    private lazy var frontPageSavedSearchesView: FrontPageSavedSearchesView = {
        let view = FrontPageSavedSearchesView(
            title: "Nytt i lagrede søk",
            buttonTitle: "Se alle",
            remoteImageDataSource: self
        )
        view.delegate = self
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(frontPageSavedSearchesView)
        frontPageSavedSearchesView.fillInSuperview()
        frontPageSavedSearchesView.configure(with: FrontPageSavedSearchFactory.create(numberOfItems: 8))
    }
}

// MARK: - FrontPageSavedSearchesViewDelegate

extension FrontPageSavedSearchesDemoView: FrontPageSavedSearchesViewDelegate {
    func frontPageSavedSearchesView(_ view: FinniversKit.FrontPageSavedSearchesView, didSelectSavedSearch savedSearch: FrontPageSavedSearchViewModel) {
        print("Did select saved search with title", savedSearch.title)
    }

    func frontPageSavedSearchesViewDidSelectActionButton(_ view: FinniversKit.FrontPageSavedSearchesView) {
        print("Did select action button")
    }
}

// MARK: - RemoteImageViewDataSource

extension FrontPageSavedSearchesDemoView: RemoteImageViewDataSource {
    public func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
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

    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        return nil
    }
}
