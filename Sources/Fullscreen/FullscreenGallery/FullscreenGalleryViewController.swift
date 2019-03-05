//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol FullscreenGalleryViewControllerDelegate: class {
    func fullscreenGalleryViewControllerDismissButtonTapped(_: FullscreenGalleryViewController)
    func fullscreenGalleryViewController(_: FullscreenGalleryViewController, didSelectImageAtIndex: Int)
}

public protocol FullscreenGalleryViewControllerDataSource: class {
    func fullscreenGalleryViewController(_: FullscreenGalleryViewController,
                                         imageForUrlString urlString: String,
                                         width: CGFloat,
                                         completionHandler handler: @escaping (String, UIImage?, Error?) -> Void)
}

public class FullscreenGalleryViewController: UIPageViewController {

    // MARK: - Public properties

    public override var prefersStatusBarHidden: Bool {
        return true
    }

    public weak var galleryDataSource: FullscreenGalleryViewControllerDataSource?
    public weak var galleryDelegate: FullscreenGalleryViewControllerDelegate?

    // MARK: - Private properties

    private static let captionFadeDuration = 0.2

    private let viewModel: FullscreenGalleryViewModel
    private let previewViewInitiallyVisible: Bool

    private var currentImageIndex: Int
    private var previewViewWasVisibleBeforePanning = false
    private var hasPerformedInitialPreviewScroll = false

    private var galleryTransitioningController: FullscreenGalleryTransitioningController? {
        return transitioningDelegate as? FullscreenGalleryTransitioningController
    }

    // MARK: - UI properties

    private lazy var backgroundView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .black
        view.isUserInteractionEnabled = false
        return view
    }()

    private lazy var overlayView: FullscreenGalleryOverlayView = {
        let overlayView = FullscreenGalleryOverlayView(withPreviewViewVisible: previewViewInitiallyVisible)
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.dataSource = self
        overlayView.delegate = self
        return overlayView
    }()

    private lazy var singleTapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: #selector(onSingleTap))
        recognizer.delegate = self
        return recognizer
    }()

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented: init(coder:)")
    }

    public override init(transitionStyle style: TransitionStyle, navigationOrientation: NavigationOrientation, options: [OptionsKey: Any]?) {
        fatalError("not implemented: init(transitionStyle:navigationOrientation:options:)")
    }

    public required init(viewModel: FullscreenGalleryViewModel, thumbnailsInitiallyVisible previewVisible: Bool) {
        self.previewViewInitiallyVisible = previewVisible
        self.viewModel = viewModel
        self.currentImageIndex = viewModel.selectedIndex
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)

        modalPresentationStyle = .overCurrentContext
        delegate = self
        dataSource = self
    }

    // MARK: - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .clear
        view.addGestureRecognizer(singleTapGestureRecognizer)

        view.addSubview(backgroundView)
        view.addSubview(overlayView)
        view.sendSubviewToBack(backgroundView)

        backgroundView.fillInSuperview()
        overlayView.fillInSuperview()

        overlayView.viewModel = viewModel
        overlayView.layoutIfNeeded()

        transitionToImage(atIndex: viewModel.selectedIndex, animated: false)
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        currentImageViewController()?.updateLayout(withPreviewViewVisible: overlayView.previewViewVisible)

        if !hasPerformedInitialPreviewScroll {
            if let currentIndex = currentImageViewController()?.imageIndex {
                overlayView.layoutIfNeeded()
                overlayView.scrollToImage(atIndex: currentIndex, animated: false)
                hasPerformedInitialPreviewScroll = true
            }
        }
    }

    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        overlayView.superviewWillTransition(to: size)
    }

    // MARK: - View interactions

    @objc private func onSingleTap() {
        let visible = !overlayView.previewViewVisible

        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
            self.overlayView.setThumbnailPreviewsVisible(visible)
            self.viewControllers?.forEach({ vc in
                guard let imageVc = vc as? FullscreenImageViewController else {
                    return
                }
                imageVc.updateLayout(withPreviewViewVisible: visible)
            })
        })
    }

    // MARK: - View modifications

    private func transitionToImage(atIndex index: Int, animated: Bool) {
        if let currentIndex = currentImageViewController()?.imageIndex {
            guard currentIndex != index else {
                return
            }
        }

        if let newController = imageViewController(forIndex: index) {
            if animated, let currentController = currentImageViewController() {
                UIView.animate(withDuration: 0.15, animations: {
                    currentController.view.alpha = 0.0
                }, completion: { _ in
                    newController.view.alpha = 0.0
                    self.setViewControllers([newController], direction: .forward, animated: false)
                    UIView.animate(withDuration: 0.15, animations: {
                        newController.view.alpha = 1.0
                    })
                })
            } else {
                setViewControllers([newController], direction: .forward, animated: false)
            }
        }
    }

    private func setThumbnailPreviewsVisible(_ visible: Bool) {
        guard visible != overlayView.previewViewVisible else {
            return
        }

        view.layoutIfNeeded()
        overlayView.setThumbnailPreviewsVisible(visible)
        viewControllers?.forEach({ vc in
            guard let imageVc = vc as? FullscreenImageViewController else { return }
            imageVc.updateLayout(withPreviewViewVisible: visible)
        })
    }

    private func currentImageViewController() -> FullscreenImageViewController? {
        return viewControllers?.first as? FullscreenImageViewController
    }
}

// MARK: - UIPageViewControllerDataSource
extension FullscreenGalleryViewController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let imageController = viewController as? FullscreenImageViewController {
            return imageViewController(forIndex: imageController.imageIndex - 1)
        }

        return nil
    }

    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let imageController = viewController as? FullscreenImageViewController {
            return imageViewController(forIndex: imageController.imageIndex + 1)
        }

        return nil
    }

    private func imageViewController(forIndex index: Int) -> FullscreenImageViewController? {
        if index < 0 || index >= viewModel.imageUrls.count {
            return nil
        }

        let vc = FullscreenImageViewController(imageIndex: index)
        vc.delegate = self
        vc.dataSource = self
        vc.updateLayout(withPreviewViewVisible: overlayView.previewViewVisible)
        return vc
    }
}

// MARK: - UIPageViewControllerDelegate
extension FullscreenGalleryViewController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let imageVc = pageViewController.viewControllers?.first as? FullscreenImageViewController else {
            return
        }

        currentImageIndex = imageVc.imageIndex
        galleryDelegate?.fullscreenGalleryViewController(self, didSelectImageAtIndex: currentImageIndex)
        overlayView.scrollToImage(atIndex: currentImageIndex, animated: true)
    }

    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingViewControllers.forEach({ vc in
            guard let imageVc = vc as? FullscreenImageViewController else { return }
            imageVc.updateLayout(withPreviewViewVisible: overlayView.previewViewVisible)
        })
    }
}

// MARK: - FullscreenImageViewControllerDataSource
extension FullscreenGalleryViewController: FullscreenImageViewControllerDataSource {
    func loadImage(forImageViewController vc: FullscreenImageViewController, dataCallback: @escaping (UIImage?) -> Void) {
        guard let galleryDataSource = galleryDataSource else {
            dataCallback(nil)
            return
        }

        let url = viewModel.imageUrls[vc.imageIndex]
        let imageWidth = min(view.bounds.width, view.bounds.height)

        galleryDataSource.fullscreenGalleryViewController(self, imageForUrlString: url, width: imageWidth, completionHandler: { (_, image, _) in
            dataCallback(image)
        })
    }

    func title(forImageViewController vc: FullscreenImageViewController) -> String? {
        return viewModel.imageCaptions[safe: vc.imageIndex]
    }

    func heightForPreviewView(forImageViewController vc: FullscreenImageViewController) -> CGFloat {
        let spacing: CGFloat = .mediumSpacing
        let previewHeight = overlayView.previewViewFrame.height
        var bottomInset: CGFloat = 0.0

        if #available(iOS 11.0, *) {
            bottomInset = view.safeAreaInsets.bottom
        }

        return previewHeight + bottomInset + spacing
    }
}

// MARK: - FullscreenImageViewControllerDelegate
extension FullscreenGalleryViewController: FullscreenImageViewControllerDelegate {
    func fullscreenImageViewControllerDidBeginPan(_: FullscreenImageViewController) {
        previewViewWasVisibleBeforePanning = overlayView.previewViewVisible

        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView.supportiveElementAlpha = 0.0

            if self.previewViewWasVisibleBeforePanning {
                self.setThumbnailPreviewsVisible(false)
            }
        })
    }

    func fullscreenImageViewControllerDidPan(_: FullscreenImageViewController, withTranslation translation: CGPoint) {
        let dist = translation.length
        let ratio = dist / 200.0

        // Let the panning fade out to 50% opacity over 200 px
        backgroundView.alpha = 1.0 - min(0.5, ratio / 2.0)
    }

    func fullscreenImageViewControllerDidEndPan(_: FullscreenImageViewController, withTranslation translation: CGPoint, velocity: CGPoint) -> Bool {
        if translation.length >= 200 || velocity.length >= 100 {
            galleryTransitioningController?.dismissVelocity = velocity
            dismiss(animated: true)
            return false
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.overlayView.supportiveElementAlpha = 1.0
                self.backgroundView.alpha = 1.0

                if self.previewViewWasVisibleBeforePanning {
                    self.setThumbnailPreviewsVisible(true)
                }
            })
            return true
        }
    }
}

// MARK: - FullscreenGalleryOverlayViewDataSource
extension FullscreenGalleryViewController: FullscreenGalleryOverlayViewDataSource {
    func fullscreenGalleryOverlayView(_ view: FullscreenGalleryOverlayView, loadImageWithWidth width: CGFloat, imageIndex index: Int, dataCallback: @escaping (Int, UIImage?) -> Void) {
        guard let galleryDataSource = galleryDataSource else {
            dataCallback(index, nil)
            return
        }

        let url = viewModel.imageUrls[index]
        galleryDataSource.fullscreenGalleryViewController(self, imageForUrlString: url, width: width, completionHandler: { (_, image, _) in
            dataCallback(index, image)
        })
    }
}

// MARK: - FullscreenGalleryOverlayViewDelegate
extension FullscreenGalleryViewController: FullscreenGalleryOverlayViewDelegate {
    func fullscreenGalleryOverlayView(_ view: FullscreenGalleryOverlayView, selectedImageAtIndex index: Int) {
        currentImageIndex = index
        galleryDelegate?.fullscreenGalleryViewController(self, didSelectImageAtIndex: currentImageIndex)

        transitionToImage(atIndex: currentImageIndex, animated: true)
    }

    func fullscreenGalleryOverlayViewDismissButtonTapped(_ view: FullscreenGalleryOverlayView) {
        galleryTransitioningController?.dismissVelocity = nil
        galleryDelegate?.fullscreenGalleryViewControllerDismissButtonTapped(self)
    }
}

// MARK: - FullscreenGalleryTransitionDestinationDelegate
extension FullscreenGalleryViewController: FullscreenGalleryTransitionDestinationDelegate {
    public func imageViewForFullscreenGalleryTransition() -> UIImageView? {
        guard let imageController = currentImageViewController() else {
            return nil
        }

        return imageController.imageViewForDismissiveAnimation()
    }

    public func displayIntermediateImageAndCalculateGlobalFrame(_ image: UIImage) -> CGRect {
        guard let fullscreenView = currentImageViewController()?.fullscreenImageView else {
            return CGRect.zero
        }

        fullscreenView.image = image

        let size = fullscreenView.contentSize
        let contentInset = fullscreenView.contentInset

        let frame = CGRect(x: contentInset.leading,
                           y: contentInset.top,
                           width: size.width,
                           height: size.height)
        return view.convert(frame, to: nil)
    }

    public func prepareForTransition(presenting: Bool) {
        if presenting {
            overlayView.supportiveElementAlpha = 0.0
            backgroundView.alpha = 0.0

            overlayView.superview?.bringSubviewToFront(overlayView)

            if previewViewInitiallyVisible {
                setThumbnailPreviewsVisible(false)
            }
        }
    }

    public func performTransitionAnimation(presenting: Bool) {
        if presenting {
            overlayView.supportiveElementAlpha = 1.0
            backgroundView.alpha = 1.0

            if previewViewInitiallyVisible {
                setThumbnailPreviewsVisible(true)
            }
        } else {
            view.alpha = 0.0
            setThumbnailPreviewsVisible(false)
        }
    }
}

// MARK: - UIGesture
extension FullscreenGalleryViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        /// gestureRecognizer(_:shouldRequireFailureOf:) is not able to properly prevent the recognizer from triggering
        /// on touches inside the GalleryPreviewView, so we need to explicitly make sure that the touch is not inside of it.
        let locationInOverlay = touch.location(in: overlayView)
        return !overlayView.previewViewFrame.contains(locationInOverlay)
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        /// Give priority to all other gesture recognizers
        return true
    }
}
