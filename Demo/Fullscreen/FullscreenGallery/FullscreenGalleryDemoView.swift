//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import FinniversKit


// MARK: - Helpers

struct FullscreenGalleryDemoViewModel: FullscreenGalleryViewModel {
    let imageUrls: [String] = [
        "https://i.pinimg.com/736x/73/de/32/73de32f9e5a0db66ec7805bb7cb3f807--navy-blue-houses-blue-and-white-houses-exterior.jpg",
        "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg",
        "http://jonvilma.com/images/house-6.jpg",
        "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
        "https://i.pinimg.com/736x/bf/6d/73/bf6d73ab0234f3ba1a615b22d2dc7e74--home-exterior-design-contemporary-houses.jpg"
    ]

    private(set) var imageCaptions: [String] = [
        "Blått hus. Bjørnen følger ikke med.",
        "Flytt inn i Syden – hjemme!",
        "Dette er den lang tekst. Det er mange som den, men denne er min. Uten den lange teksten min er jeg ingenting. Uten meg er den lange teksten min ingenting.",
        "Herskapelig og fint.\nMerk mangelen på rovdyr i hagen.",
        "Live here or be square 📦",
    ]
}

class FullscreenGalleryDemoPreviewCell: UICollectionViewCell {
    private(set) var imageUrl: String?

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        // translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(imageView)
        setFocused(false)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumSpacing),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.mediumSpacing),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .mediumSpacing),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.mediumSpacing)
        ])
    }

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        setFocused(false)
    }

    // MARK: - Public methods

    public func setFocused(_ focus: Bool) {
        if focus {
            backgroundColor = .cherry
        } else {
            backgroundColor = .banana
        }
    }

    public func configure(withUrl url: String) {
        imageUrl = url

        downloadImage(withUrl: url, dataCallback: { [weak self] (fetchedUrl, image) in
            if fetchedUrl == self?.imageUrl {
                self?.imageView.image = image
            }
        })
    }
}

private func downloadImage(withUrl urlString: String, dataCallback: @escaping (String, UIImage?) -> Void) {
    guard let url = URL(string: urlString) else {
        dataCallback(urlString, nil)
        return
    }

    let task = URLSession.shared.dataTask(with: url) { data, _, _ in
        DispatchQueue.main.async {
            if let data = data, let image = UIImage(data: data) {
                dataCallback(urlString, image)
            } else {
                dataCallback(urlString, nil)
            }
        }
    }

    task.resume()
}

// MARK: - Demo view

class FullscreenGalleryDemoView: UIView {

    // MARK: - Public properties

    var parentViewController: UIViewController?

    // MARK: - Private properties

    private let viewModel = FullscreenGalleryDemoViewModel()

    private lazy var collectionCellHeight: CGFloat = {
        switch (UIDevice.current.userInterfaceIdiom) {
        case .pad:
            return 250.0
        default:
            return 170.0
        }
    }()

    private var selectedIndex: Int? = nil

    // MARK: - UI properties

    private lazy var helpLabel: Label = {
        let label = Label(style: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Tap an image to open the fullscreen gallery"
        label.textAlignment = .center
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: collectionCellHeight, height: collectionCellHeight)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        collectionView.register(FullscreenGalleryDemoPreviewCell.self)
        return collectionView
    }()

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        addSubview(helpLabel)
        addSubview(collectionView)

        NSLayoutConstraint.activate([
            helpLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            helpLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            helpLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.largeSpacing),

            collectionView.heightAnchor.constraint(equalToConstant: collectionCellHeight + CGFloat.largeSpacing),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: - Private methods

    private func displayFullscreenGallery(forIndex index: Int) {
        if let viewController = parentViewController {
            let gallery = FullscreenGalleryViewController()
            gallery.galleryDataSource = self
            gallery.galleryDelegate = self
            viewController.present(gallery, animated: true)
        }
    }
}

// MARK: - FullscreenGallery

extension FullscreenGalleryDemoView: FullscreenGalleryViewControllerDataSource {
    public func modelForFullscreenGalleryViewController(_ vc: FullscreenGalleryViewController) -> FullscreenGalleryViewModel {
        return viewModel
    }

    public func initialImageIndexForFullscreenGalleryViewController(_ vc: FullscreenGalleryViewController) -> Int {
        return selectedIndex ?? 0
    }

    public func fullscreenGalleryViewController(_ vc: FullscreenGalleryViewController, loadImageAtIndex index: Int, dataCallback: @escaping (UIImage?) -> Void) {
        downloadImage(withUrl: viewModel.imageUrls[index], dataCallback: { _, image in
            dataCallback(image)
        })
    }
}

extension FullscreenGalleryDemoView: FullscreenGalleryViewControllerDelegate {

}

// MARK: - UICollectionView

extension FullscreenGalleryDemoView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(FullscreenGalleryDemoPreviewCell.self, for: indexPath)
        cell.configure(withUrl: viewModel.imageUrls[indexPath.row])
        cell.setFocused(selectedIndex == indexPath.row)
        return cell
    }
}

extension FullscreenGalleryDemoView: UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var pathsToUpdate = [indexPath]

        if let lastSelected = selectedIndex, lastSelected != indexPath.row {
            pathsToUpdate.append(IndexPath(row: lastSelected, section: 0))
        }

        selectedIndex = indexPath.row
        collectionView.reloadItems(at: pathsToUpdate)
        displayFullscreenGallery(forIndex: indexPath.row)
    }
}

