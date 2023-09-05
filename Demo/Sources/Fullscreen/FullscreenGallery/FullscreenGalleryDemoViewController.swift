//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import FinniversKit
import DemoKit

// MARK: - Helpers

private struct DemoViewModel: FullscreenGalleryViewModel {
    let imageUrls: [String]
    let imageCaptions: [String]
    let selectedIndex: Int
}

private class DemoPreviewCell: UICollectionViewCell {
    private(set) var imageIndex: Int?
    private(set) var imageUrl: String?

    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
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
        contentView.addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .spacingS),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingS),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -.spacingS),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -.spacingS),
        ])
    }

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()

        imageView.image = nil
        imageUrl = nil
        imageIndex = nil
    }

    // MARK: - Public methods

    public func configure(withIndex index: Int, url: String) {
        imageUrl = url
        imageIndex = index

        ImageDownloader.shared.downloadImage(withUrl: url, dataCallback: { [weak self] (fetchedUrl, image, _) in
            guard let self = self else { return }
            if fetchedUrl == self.imageUrl {
                self.imageView.image = image
            }
        })
    }
}

private class ImageDownloader: FullscreenGalleryViewControllerDataSource {
    static let shared = ImageDownloader()

    var simulatedDelayMs: UInt32 = 0

    func downloadImage(withUrl urlString: String, dataCallback: @escaping (String, UIImage?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            dataCallback(urlString, nil, nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { [simulatedDelayMs] data, _, _ in
            if simulatedDelayMs != 0 {
                usleep(simulatedDelayMs * 1000)
            }

            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    dataCallback(urlString, image, nil)
                } else {
                    dataCallback(urlString, nil, nil)
                }
            }
        }

        task.resume()
    }

    func fullscreenGalleryViewController(_: FullscreenGalleryViewController,
                                         imageForUrlString urlString: String,
                                         width _: CGFloat,
                                         completionHandler handler: @escaping (String, UIImage?, Error?) -> Void) {
        downloadImage(withUrl: urlString, dataCallback: handler)
    }
}

// MARK: - Demo view

class FullscreenGalleryDemoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, Demoable {

    // MARK: - Private properties

    let imageUrls: [String] = [
        "https://i.pinimg.com/736x/73/de/32/73de32f9e5a0db66ec7805bb7cb3f807--navy-blue-houses-blue-and-white-houses-exterior.jpg",
        "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
        "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg",
        "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
        "https://i.pinimg.com/736x/bf/6d/73/bf6d73ab0234f3ba1a615b22d2dc7e74--home-exterior-design-contemporary-houses.jpg",
        "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
        "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg",
        "https://i.pinimg.com/736x/73/de/32/73de32f9e5a0db66ec7805bb7cb3f807--navy-blue-houses-blue-and-white-houses-exterior.jpg",
        "https://i.pinimg.com/736x/11/f0/79/11f079c03af31321fd5029f72a4586b1--exterior-houses-house-exteriors.jpg",
        "https://i.pinimg.com/736x/73/de/32/73de32f9e5a0db66ec7805bb7cb3f807--navy-blue-houses-blue-and-white-houses-exterior.jpg",
        "http://i3.au.reastatic.net/home-ideas/raw/a96671bab306bcb39783bc703ac67f0278ffd7de0854d04b7449b2c3ae7f7659/facades.jpg"
    ]

    let imageCaptions: [String] = [
        "Blått hus. Bjørnen følger ikke med.",
        "Flytt inn i Syden – hjemme!",
        "Dette er den lang tekst. Det er mange som den, men denne er min. Uten den lange teksten min er jeg ingenting. Uten meg er den lange teksten min ingenting.",
        "Herskapelig og fint.\nMerk mangelen på rovdyr i hagen.",
        "Live here or be square 📦",
        "test",
        "test",
        "test",
        "test",
        "test",
        "test",
    ]

    private var selectedIndex: Int?

    private lazy var transitionController = FullscreenGalleryTransitioningController(withPresenterDelegate: self)

    private lazy var collectionCellHeight: CGFloat = {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return 250.0
        default:
            return 170.0
        }
    }()

    // MARK: - UI properties

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: collectionCellHeight, height: collectionCellHeight)

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .black
        collectionView.register(DemoPreviewCell.self)
        return collectionView
    }()

    private lazy var thumbnailSwitch: UISwitch = {
        let switchView = UISwitch(withAutoLayout: true)
        switchView.onTintColor = .btnPrimary
        switchView.isSelected = false
        return switchView
    }()

    private lazy var thumbnailLabel: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Show thumbnails immediately"
        return label
    }()

    private lazy var simulateLoadingSwitch: UISwitch = {
        let switchView = UISwitch(withAutoLayout: true)
        switchView.onTintColor = .btnPrimary
        switchView.isSelected = false
        switchView.addTarget(self, action: #selector(loadSimulationSwitchToggled), for: .valueChanged)
        return switchView
    }()

    private lazy var simulateLoadingLabel: Label = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .left
        label.text = "Simulate 200ms image load delay"
        return label
    }()

    private lazy var helpLabel: Label = {
        let label = Label(style: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Tap an image to open the fullscreen gallery"
        label.textAlignment = .center
        return label
    }()

    // MARK: - Init

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(collectionView)
        view.addSubview(thumbnailSwitch)
        view.addSubview(thumbnailLabel)
        view.addSubview(simulateLoadingSwitch)
        view.addSubview(simulateLoadingLabel)
        view.addSubview(helpLabel)

        NSLayoutConstraint.activate([
            collectionView.heightAnchor.constraint(equalToConstant: collectionCellHeight + .spacingXL),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            thumbnailSwitch.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: .spacingXL),
            thumbnailSwitch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .spacingXL),

            thumbnailLabel.leadingAnchor.constraint(equalTo: thumbnailSwitch.trailingAnchor, constant: .spacingM),
            thumbnailLabel.centerYAnchor.constraint(equalTo: thumbnailSwitch.centerYAnchor),

            simulateLoadingSwitch.topAnchor.constraint(equalTo: thumbnailSwitch.bottomAnchor, constant: .spacingS),
            simulateLoadingSwitch.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .spacingXL),

            simulateLoadingLabel.leadingAnchor.constraint(equalTo: simulateLoadingSwitch.trailingAnchor, constant: .spacingM),
            simulateLoadingLabel.centerYAnchor.constraint(equalTo: simulateLoadingSwitch.centerYAnchor),

            helpLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .spacingM),
            helpLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.spacingM),
            helpLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: .spacingXL)
        ])
    }

    // MARK: - Private methods

    private func displayFullscreenGallery(forIndex index: Int) {
        let viewModel = DemoViewModel(imageUrls: imageUrls, imageCaptions: imageCaptions, selectedIndex: index)

        let gallery = FullscreenGalleryViewController(viewModel: viewModel, thumbnailsInitiallyVisible: thumbnailSwitch.isOn)
        gallery.galleryDelegate = self
        gallery.galleryDataSource = ImageDownloader.shared
        gallery.transitioningDelegate = transitionController

        present(gallery, animated: true)
    }

    @objc private func loadSimulationSwitchToggled() {
        if simulateLoadingSwitch.isOn {
            ImageDownloader.shared.simulatedDelayMs = 200
        } else {
            ImageDownloader.shared.simulatedDelayMs = 0
        }
    }

    // MARK: - UICollectionView

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(imageUrls.count, imageCaptions.count)
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(DemoPreviewCell.self, for: indexPath)
        cell.configure(withIndex: indexPath.row, url: imageUrls[indexPath.row])
        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        displayFullscreenGallery(forIndex: indexPath.row)
    }

}

// MARK: - FullscreenGalleryTransitionSourceDelegate

extension FullscreenGalleryDemoViewController: FullscreenGalleryTransitionPresenterDelegate {
    public func imageViewForFullscreenGalleryTransitionIn() -> UIImageView? {
        let indexPath = IndexPath(row: selectedIndex ?? 0, section: 0)
        let cell = collectionView.cellForItem(at: indexPath) as? DemoPreviewCell
        return cell?.imageView
    }

    public func viewForFullscreenGalleryTransitionOut() -> UIView? {
        return imageViewForFullscreenGalleryTransitionIn()
    }

    public func fullscreenGalleryTransitionInCompleted() { }
    public func fullscreenGalleryTransitionOutCompleted() { }
}

// MARK: - FullscreenGalleryViewControllerDelegate

extension FullscreenGalleryDemoViewController: FullscreenGalleryViewControllerDelegate {
    public func fullscreenGalleryViewControllerDismissButtonTapped(_ controller: FullscreenGalleryViewController) {
        controller.dismiss(animated: true)
    }

    public func fullscreenGalleryViewController(_ controller: FullscreenGalleryViewController, didSelectImageAtIndex index: Int) {
        selectedIndex = index
        let indexPath = IndexPath(row: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
}
