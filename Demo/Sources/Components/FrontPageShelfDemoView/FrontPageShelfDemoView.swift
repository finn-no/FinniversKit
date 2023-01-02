import FinniversKit

class FrontPageShelfDemoView: UIView {
    private lazy var shelfView: FrontPageSavedSearchView = {
        let view = FrontPageSavedSearchView(withDatasource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.shelfDelegate = self
        return view
    }()

    private var savedItems: [SavedSearchShelfViewModel] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        savedItems = SavedSearchShelfFactory.create(numberOfItems: 10)
        addSubview(shelfView)
        shelfView.fillInSuperview()
        shelfView.reloadShelf()
    }
}

extension FrontPageShelfDemoView: FrontPageShelfViewDataSource {
    func frontPageShelfView(_ frontPageShelfView: FrontPageSavedSearchView, titleForSectionAt index: Int) -> String {
        "Lagrede søk"
    }

    func frontPageShelfView(_ frontPageShelfView: FrontPageSavedSearchView, titleForButtonForSectionAt index: Int) -> String {
        "Se alle"
    }

    func frontPageShelfView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, withItem item: AnyHashable) -> UICollectionViewCell? {
        guard let model = item as? SavedSearchShelfViewModel else { return nil }

        let cell = collectionView.dequeue(SavedSearchShelfCell.self, for: indexPath)
        cell.configure(withModel: model)
        cell.imageDatasource = self
        cell.loadImage()
        return cell
    }

    func datasource(forSection section: FrontPageSavedSearchView.Section) -> [AnyHashable] {
        switch section {
        case .savedSearch:
            return savedItems
        }
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

extension FrontPageShelfDemoView: FrontPageShelfDelegate {
    func frontPageShelfView(_ view: FrontPageSavedSearchView, didSelectHeaderForSection section: FrontPageSavedSearchView.Section) {
        print("Header for section \(section) pressed")
    }

    func frontPageShelfView(_ view: FrontPageSavedSearchView, didSelectSavedSearchItem item: SavedSearchShelfViewModel) {
        print("selected saved item")
    }
}
