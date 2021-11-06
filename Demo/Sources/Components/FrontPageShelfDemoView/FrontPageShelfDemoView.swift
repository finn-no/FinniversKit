import FinniversKit

class FrontPageShelfDemoView: UIView {
    private lazy var shelfView: FrontPageShelfView = {
        let view = FrontPageShelfView(withDatasource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var favoriteItems: [RecentlyFavoritedViewmodel] = []
    
    private var savedItems: [SavedSearchShelfViewModel] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        favoriteItems = RecentlyFavoritedFactory.create(numberOfItems: 10)
        savedItems = SavedSearchShelfFactory.create(numberOfItems: 10)
        addSubview(shelfView)
        shelfView.fillInSuperview()
    }
}

extension FrontPageShelfDemoView: FrontPageShelfViewDataSource {
    func frontPageShelfView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath, withItem item: AnyHashable) -> UICollectionViewCell? {
        if let model = item as? SavedSearchShelfViewModel {
            let cell = collectionView.dequeue(SavedSearchShelfCell.self, for: indexPath)
            cell.configure(withModel: model)
            cell.imageDatasource = self
            cell.loadImage()
            
            return cell
        } else if let model = item as? RecentlyFavoritedViewmodel {
            let cell = collectionView.dequeue(RecentlyFavoritedShelfCell.self, for: indexPath)
            cell.configure(withModel: model)
            cell.datasource = self
            cell.loadImage()
            return cell
        }
        return nil
    }
    
    func frontPageShelfView(cellClassesIn collectionView: UICollectionView) -> [UICollectionViewCell.Type] {
        [SavedSearchShelfCell.self, RecentlyFavoritedShelfCell.self]
    }
    
    func datasource(forSection section: FrontPageShelfView.Section) -> [AnyHashable] {
        switch section {
        case .savedSearch:
            return savedItems
        case .recentlyFavorited:
            return favoriteItems
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

