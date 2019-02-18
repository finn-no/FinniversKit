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

    private static let zoomStep: CGFloat = 2.0

    private weak var dataSource: FullscreenImageViewControllerDataSource?
    private var image: UIImage?

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(frame: .zero)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()

    private lazy var tapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap))
        recognizer.numberOfTapsRequired = 2
        recognizer.numberOfTouchesRequired = 1
        return recognizer
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
        scrollView.addGestureRecognizer(tapRecognizer)

        scrollView.addSubview(imageView)
        imageView.fillInSuperview()

        loadImage()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [weak self] context in
            self?.calculateZoomLimits(forViewSize: size)
            self?.adjustImageInsets(forViewSize: size)
        })
    }

    // MARK: - Private methods

    private func calculateZoomLimits(forViewSize viewSize: CGSize) {
        guard let image = self.image else {
            return
        }

        let constrainedImageSize: CGFloat
        let constrainedScreenSize: CGFloat

        let screenAspectRatio = viewSize.width / viewSize.height
        let imageAspectRatio = image.size.width / image.size.height

        if (screenAspectRatio < imageAspectRatio) {
            constrainedImageSize = image.size.width
            constrainedScreenSize = viewSize.width
        } else {
            constrainedImageSize = image.size.height
            constrainedScreenSize = viewSize.height
        }

        let minZoomScale = constrainedScreenSize / constrainedImageSize
        let maxZoomScale = max(2.5 * minZoomScale, (2.0 * constrainedImageSize) / constrainedScreenSize)

        scrollView.maximumZoomScale = maxZoomScale
        scrollView.minimumZoomScale = minZoomScale
        scrollView.zoomScale = minZoomScale

        // The contentSize will be set automatically at a later point in time, but in order
        // to be able to work with it immediately we need to set it manually.
        scrollView.contentSize = CGSize(width: minZoomScale * image.size.width, height: minZoomScale * image.size.height)
    }

    private func adjustImageInsets(forViewSize viewSize: CGSize) {
        let offsetX = max((viewSize.width - scrollView.contentSize.width) * 0.5, 0)
        let offsetY = max((viewSize.height - scrollView.contentSize.height) * 0.5, 0)
        scrollView.contentInset = UIEdgeInsets(top: offsetY, leading: offsetX, bottom: 0, trailing: 0)
    }

    private func loadImage() {
        dataSource?.loadImage(forImageViewController: self, dataCallback: { [weak self] image in
            guard let self = self else { return }
            self.imageView.image = image
            self.image = image
            self.calculateZoomLimits(forViewSize: self.view.bounds.size)
            self.adjustImageInsets(forViewSize: self.view.bounds.size)
        })
    }

    // MARK: - Tap gesture handling

    @objc private func onDoubleTap(_ recognizer: UIGestureRecognizer) {
        var newZoom: CGFloat = scrollView.zoomScale * FullscreenImageViewController.zoomStep
        if newZoom >= scrollView.maximumZoomScale * 0.9 {
            newZoom = scrollView.minimumZoomScale
        }

        var center = recognizer.location(in: recognizer.view)
        center.x /= scrollView.zoomScale
        center.y /= scrollView.zoomScale

        let newRect = zoomRect(forScale: newZoom, withCenter: center)
        scrollView.zoom(to: newRect, animated: true)
    }

    private func zoomRect(forScale scale: CGFloat, withCenter center: CGPoint) -> CGRect {
        var zoomRect = CGRect()

        zoomRect.size.height = scrollView.frame.size.height / scale;
        zoomRect.size.width = scrollView.frame.size.width  / scale;

        zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);

        return zoomRect
    }
}

extension FullscreenImageViewController: UIScrollViewDelegate {
    public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        adjustImageInsets(forViewSize: view.bounds.size)
    }
}
