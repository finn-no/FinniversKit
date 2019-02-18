//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

protocol FullscreenImageViewControllerDataSource: class {
    func loadImage(forImageViewController vc: FullscreenImageViewController, dataCallback: @escaping (UIImage?) -> Void)
    func title(forImageViewController vc: FullscreenImageViewController) -> String?
}

class FullscreenImageViewController: UIViewController {

    // MARK: - Private properties

    private weak var dataSource: FullscreenImageViewControllerDataSource?

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        return scrollView
    }()

    // MARK: - Public properties

    public let imageIndex: Int

    // MARK: - Init

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("not implemented: init(nibName:bundle:)")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented: init(coder:)")
    }

    init(imageIndex: Int, dataSource: FullscreenImageViewControllerDataSource) {
        self.dataSource = dataSource
        self.imageIndex = imageIndex
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        scrollView.fillInSuperview()
        scrollView.bounds = view.bounds

        scrollView.addSubview(imageView)
        imageView.fillInSuperview()

        loadImage()
    }

    // MARK: - Private methods

    private func calculateZoomLimits(forImage image: UIImage) {
        let screenWidth = view.bounds.width
        let imageWidth = image.size.width

        let minZoomScale = screenWidth / imageWidth
        let maxZoomScale = min(2.0, (2.5 * imageWidth) / screenWidth)

        scrollView.maximumZoomScale = maxZoomScale
        scrollView.minimumZoomScale = minZoomScale
        scrollView.zoomScale = minZoomScale

        // The contentSize will be set automatically at a later point in time, but in order
        // to be able to work with it immediately we need to set it manually.
        scrollView.contentSize = CGSize(width: minZoomScale * image.size.width, height: minZoomScale * image.size.height)
    }

    private func adjustImageInsets() {
        let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, leading: offsetX, bottom: 0, trailing: 0)
    }

    private func loadImage() {
        dataSource?.loadImage(forImageViewController: self, dataCallback: { [weak self] image in
            self?.imageView.image = image

            if let image = image {
                self?.calculateZoomLimits(forImage: image)
                self?.adjustImageInsets()
            }
        })
    }
}

extension FullscreenImageViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        adjustImageInsets()
    }
}
