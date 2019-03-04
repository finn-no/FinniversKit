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
    private static let dismissButtonSize: CGFloat = 30.0

    private let viewModel: FullscreenGalleryViewModel
    private let previewViewInitiallyVisible: Bool

    private var currentImageIndex: Int
    private var previewViewVisible: Bool
    private var previewViewWasVisibleBeforePanning = false
    private var hasPerformedInitialPreviewScroll = false

    private var galleryTransitioningController: FullscreenGalleryTransitioningController? {
        return transitioningDelegate as? FullscreenGalleryTransitioningController
    }

    // MARK: - UI properties

    private lazy var backgroundView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black
        view.isUserInteractionEnabled = false
        return view
    }()

    private lazy var captionLabel: Label = {
        let label = Label(style: .title4)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .milk
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        label.shadowOffset = CGSize(width: 1.0, height: 1.0)
        label.shadowColor = .black
        return label
    }()

    private lazy var dismissButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        button.backgroundColor = .clear

        let removeImage = UIImage(named: .remove)
        button.setImage(removeImage, for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()

    private lazy var previewView: GalleryPreviewView = {
        let previewView = GalleryPreviewView()
        previewView.translatesAutoresizingMaskIntoConstraints = false
        previewView.delegate = self
        previewView.dataSource = self
        return previewView
    }()

    private lazy var previewViewVisibleConstraint: NSLayoutConstraint = {
        return previewView.bottomAnchor.constraint(equalTo: view.safeLayoutGuide.bottomAnchor)
    }()

    private lazy var previewViewHiddenConstraint: NSLayoutConstraint = {
        // The constant exists to prevent the preview-view from jumping back into the visible area
        // during the dismissal animation.
        return previewView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: .mediumLargeSpacing)
    }()

    private lazy var singleTapGestureRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.numberOfTapsRequired = 1
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
        self.previewViewVisible = previewVisible
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

        previewView.viewModel = viewModel

        view.backgroundColor = .clear
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView)
        backgroundView.fillInSuperview()

        view.addSubview(captionLabel)
        view.addSubview(dismissButton)
        view.addSubview(previewView)
        view.addGestureRecognizer(singleTapGestureRecognizer)

        let initialPreviewViewVisibilityConstraint = previewViewVisible
            ? previewViewVisibleConstraint
            : previewViewHiddenConstraint

        NSLayoutConstraint.activate([
            captionLabel.centerXAnchor.constraint(equalTo: view.safeLayoutGuide.centerXAnchor),
            captionLabel.widthAnchor.constraint(lessThanOrEqualTo: view.safeLayoutGuide.widthAnchor, constant: -(2 * CGFloat.mediumLargeSpacing)),
            captionLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.safeLayoutGuide.bottomAnchor, constant: -.mediumSpacing),
            captionLabel.bottomAnchor.constraint(lessThanOrEqualTo: previewView.topAnchor, constant: -.mediumSpacing),

            dismissButton.leadingAnchor.constraint(equalTo: view.safeLayoutGuide.leadingAnchor, constant: .mediumLargeSpacing),
            dismissButton.topAnchor.constraint(equalTo: view.safeLayoutGuide.topAnchor, constant: .mediumLargeSpacing),
            dismissButton.widthAnchor.constraint(equalToConstant: FullscreenGalleryViewController.dismissButtonSize),
            dismissButton.heightAnchor.constraint(equalToConstant: FullscreenGalleryViewController.dismissButtonSize),

            previewView.leadingAnchor.constraint(lessThanOrEqualTo: view.leadingAnchor),
            previewView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor),
            previewView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            initialPreviewViewVisibilityConstraint
        ])

        transitionToImage(atIndex: viewModel.selectedIndex, animated: false)
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        currentImageViewController()?.updateLayout(withPreviewViewVisible: previewViewVisible)

        if !hasPerformedInitialPreviewScroll {
            if let currentIndex = currentImageViewController()?.imageIndex {
                previewView.layoutIfNeeded()
                previewView.scrollToItem(atIndex: currentIndex, animated: false)
                hasPerformedInitialPreviewScroll = true
            }
        }
    }

    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        previewView.superviewWillTransition(to: size)
    }

    // MARK: - View interactions

    @objc private func dismissButtonTapped() {
        galleryTransitioningController?.dismissVelocity = nil
        galleryDelegate?.fullscreenGalleryViewControllerDismissButtonTapped(self)
    }

    @objc private func onSingleTap(_ gestureRecognizer: UIGestureRecognizer) {
        setThumbnailPreviewsVisible(!previewViewVisible, animated: true)
    }

    // MARK: - View modifications

    private func transitionToImage(atIndex index: Int, animated: Bool) {
        if let currentIndex = currentImageViewController()?.imageIndex {
            guard currentIndex != index else {
                return
            }
        }

        setCaptionLabel(index: index)

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

    private func setThumbnailPreviewsVisible(_ visible: Bool, animated: Bool) {
        guard visible != previewViewVisible else {
            return
        }

        if visible {
            NSLayoutConstraint.deactivate([previewViewHiddenConstraint])
            NSLayoutConstraint.activate([previewViewVisibleConstraint])
        } else {
            NSLayoutConstraint.deactivate([previewViewVisibleConstraint])
            NSLayoutConstraint.activate([previewViewHiddenConstraint])
        }

        previewViewVisible = visible

        let performTransition = {
            self.view.layoutIfNeeded()
            self.viewControllers?.forEach({ vc in
                guard let imageVc = vc as? FullscreenImageViewController else { return }
                imageVc.updateLayout(withPreviewViewVisible: visible)
            })
        }

        if animated {
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: [], animations: {
                performTransition()
            }, completion: nil)
        } else {
            performTransition()
        }
    }

    private func setCaptionLabel(index: Int) {
        let caption: String? = {
            if index >= 0 && index < viewModel.imageCaptions.count {
                return viewModel.imageCaptions[index]
            } else {
                return nil
            }
        }()

        UIView.transition(with: captionLabel, duration: FullscreenGalleryViewController.captionFadeDuration, options: .transitionCrossDissolve, animations: { [weak self] in
            self?.captionLabel.text = caption
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
        vc.updateLayout(withPreviewViewVisible: previewViewVisible)
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

        setCaptionLabel(index: currentImageIndex)
        previewView.scrollToItem(atIndex: currentImageIndex, animated: true)
    }

    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pendingViewControllers.forEach({ vc in
            guard let imageVc = vc as? FullscreenImageViewController else { return }

            imageVc.updateLayout(withPreviewViewVisible: previewViewVisible)
        })
    }
}

// MARK: - UIGesture
extension FullscreenGalleryViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        /// gestureRecognizer(_:shouldRequireFailureOf:) is not able to properly prevent the recognizer from triggering
        /// on touches inside the GalleryPreviewView, so we need to explicitly make sure that the touch is not inside of it.
        let locationInPreview = touch.location(in: previewView)
        return !previewView.bounds.contains(locationInPreview)
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        /// Give priority to all other gesture recognizers
        return true
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
        if vc.imageIndex < 0 || vc.imageIndex >= viewModel.imageCaptions.count {
            return nil
        }

        return viewModel.imageCaptions[vc.imageIndex]
    }

    func heightForPreviewView(forImageViewController vc: FullscreenImageViewController) -> CGFloat {
        let spacing: CGFloat = .mediumSpacing
        let previewHeight = previewView.frame.height
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
        previewViewWasVisibleBeforePanning = previewViewVisible

        UIView.animate(withDuration: 0.3, animations: {
            self.captionLabel.alpha = 0.0
            self.dismissButton.alpha = 0.0

            if self.previewViewVisible {
                self.setThumbnailPreviewsVisible(false, animated: false)
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
                self.captionLabel.alpha = 1.0
                self.dismissButton.alpha = 1.0
                self.backgroundView.alpha = 1.0

                if self.previewViewWasVisibleBeforePanning {
                    self.setThumbnailPreviewsVisible(true, animated: false)
                }
            })
            return true
        }
    }
}

// MARK: - GalleryPreviewViewDataSource
extension FullscreenGalleryViewController: GalleryPreviewViewDataSource {
    func galleryPreviewView(_: GalleryPreviewView, loadImageWithWidth width: CGFloat, imageIndex index: Int, dataCallback: @escaping (Int, UIImage?) -> Void) {
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

// MARK: - GalleryPreviewViewDelegate
extension FullscreenGalleryViewController: GalleryPreviewViewDelegate {
    func galleryPreviewView(_ previewView: GalleryPreviewView, selectedImageAtIndex index: Int) {
        currentImageIndex = index
        galleryDelegate?.fullscreenGalleryViewController(self, didSelectImageAtIndex: currentImageIndex)

        transitionToImage(atIndex: currentImageIndex, animated: true)
        previewView.scrollToItem(atIndex: currentImageIndex, animated: true)
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
            captionLabel.alpha = 0.0
            dismissButton.alpha = 0.0
            backgroundView.alpha = 0.0

            captionLabel.superview?.bringSubviewToFront(captionLabel)

            if previewViewInitiallyVisible {
                setThumbnailPreviewsVisible(false, animated: false)
            }
        }
    }

    public func performTransitionAnimation(presenting: Bool) {
        if presenting {
            captionLabel.alpha = 1.0
            dismissButton.alpha = 1.0
            backgroundView.alpha = 1.0

            if previewViewInitiallyVisible {
                setThumbnailPreviewsVisible(true, animated: false)
            }
        } else {
            view.alpha = 0.0
            setThumbnailPreviewsVisible(false, animated: false)
        }
    }
}
