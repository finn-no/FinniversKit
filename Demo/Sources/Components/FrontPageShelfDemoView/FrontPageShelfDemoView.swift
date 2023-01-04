import FinniversKit

class FrontPageShelfDemoView: UIView {
    private lazy var shelfView: FrontPageSavedSearchesView = {
        let view = FrontPageSavedSearchesView(
            title: "Nytt i lagrede søk",
            buttonTitle: "Se alle",
            remoteImageDataSource: self,
            withAutoLayout: true
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

    private func setup() {
        addSubview(shelfView)
        shelfView.fillInSuperview()
        shelfView.configure(with: SavedSearchShelfFactory.create(numberOfItems: 10))
    }
}

extension FrontPageShelfDemoView: RemoteImageViewDataSource {
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? {
        return nil
    }

    func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data {
                    completion(UIImage(data: data))
                }
            }
        }

        task.resume()
    }

    func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {
    }
}

extension FrontPageShelfDemoView: FrontPageSavedSearchesViewDelegate {
    func frontPageSavedSearchesView(_ view: FinniversKit.FrontPageSavedSearchesView, didSelectSavedSearchItem item: FinniversKit.FrontPageSavedSearchViewModel) {
        print("Did select saved search with title", item.title)
    }

    func frontPageSavedSearchesViewDidSelectActionButton(_ view: FinniversKit.FrontPageSavedSearchesView) {
        print("Did select action button")
    }
}
