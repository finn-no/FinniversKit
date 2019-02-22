//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol FullscreenGalleryViewControllerDataSource: class {
    func modelForFullscreenGalleryViewController(_ vc: FullscreenGalleryViewController) -> FullscreenGalleryViewModel
    func initialImageIndexForFullscreenGalleryViewController(_ vc: FullscreenGalleryViewController) -> Int
    func fullscreenGalleryViewController(_ vc: FullscreenGalleryViewController, loadImageAtIndex index: Int, dataCallback: @escaping (UIImage?) -> Void)
}

public protocol FullscreenGalleryViewControllerDelegate: class {
    func fullscreenGalleryViewController(_ vc: FullscreenGalleryViewController, intendsToDismissFromImageWithIndex index: Int)
}

public class FullscreenGalleryViewController: UIPageViewController {

    // MARK: - Public properties

    public weak var galleryDataSource: FullscreenGalleryViewControllerDataSource?
    public weak var galleryDelegate: FullscreenGalleryViewControllerDelegate?

    public override var prefersStatusBarHidden: Bool {
        return true
    }

    // MARK: - Private properties

    private let captionFadeDuration = 0.2
    private let dismissButtonSize: CGFloat = 30.0
    private let previewViewInitiallyVisible: Bool

    private var viewModel: FullscreenGalleryViewModel?
    private var previewViewVisible: Bool
    private var hasPerformedInitialPreviewScroll: Bool = false

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
        label.backgroundColor = UIColor(r: 0, g: 0, b: 0, a: 0.4)
        label.shadowOffset = CGSize(width: 1.0, height: 1.0);
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
        button.setImage(removeImage, for: .selected)
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
        return previewView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor)
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

    private lazy var safeLayoutGuide: UILayoutGuide = {
        if #available(iOS 11.0, *) {
            return view.safeAreaLayoutGuide
        } else {
            return view.layoutMarginsGuide
        }
    }()

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented: init(coder:)")
    }

    public override init(transitionStyle style: TransitionStyle, navigationOrientation: NavigationOrientation, options: [OptionsKey: Any]?) {
        fatalError("not implemented: init(transitionStyle:navigationOrientation:options:)")
    }

    public init(thumbnailsInitiallyVisible previewVisible: Bool) {
        self.previewViewInitiallyVisible = previewVisible
        self.previewViewVisible = previewVisible
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)

        modalPresentationStyle = .overCurrentContext
        delegate = self
        dataSource = self
    }

    convenience init() {
        self.init(thumbnailsInitiallyVisible: false)
    }

    // MARK : - Lifecycle

    public override func loadView() {
        viewModel = galleryDataSource?.modelForFullscreenGalleryViewController(self)
        previewView.viewModel = viewModel

        super.loadView()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

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
            captionLabel.centerXAnchor.constraint(equalTo: safeLayoutGuide.centerXAnchor),
            captionLabel.widthAnchor.constraint(lessThanOrEqualTo: safeLayoutGuide.widthAnchor, constant: -(2 * CGFloat.mediumLargeSpacing)),
            captionLabel.bottomAnchor.constraint(lessThanOrEqualTo: safeLayoutGuide.bottomAnchor, constant: -.mediumSpacing),
            captionLabel.bottomAnchor.constraint(lessThanOrEqualTo: previewView.topAnchor, constant: -.mediumSpacing),

            dismissButton.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor, constant: .mediumLargeSpacing),
            dismissButton.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor, constant: .mediumLargeSpacing),
            dismissButton.widthAnchor.constraint(equalToConstant: dismissButtonSize),
            dismissButton.heightAnchor.constraint(equalToConstant: dismissButtonSize),

            previewView.leadingAnchor.constraint(lessThanOrEqualTo: view.leadingAnchor),
            previewView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor),
            previewView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            initialPreviewViewVisibilityConstraint
        ])

        view.layoutIfNeeded()

        let initialImageIndex = galleryDataSource?.initialImageIndexForFullscreenGalleryViewController(self) ?? 0
        transitionToImage(atIndex: initialImageIndex, animated: false)
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
        let currentIndex = currentImageViewController()?.imageIndex ?? 0
        galleryDelegate?.fullscreenGalleryViewController(self, intendsToDismissFromImageWithIndex: currentIndex)

        dismiss(animated: true)
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
            print("The required constraints are already in place")
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
                guard let imageVc = self.currentImageViewController() else { return }
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
            if index >= 0 && index < viewModel?.imageCaptions.count ?? 0 {
                return viewModel?.imageCaptions[index]
            } else {
                return nil
            }
        }()

        UIView.transition(with: captionLabel, duration: captionFadeDuration, options: .transitionCrossDissolve, animations: { [weak self] in
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
        if index < 0 || index >= viewModel?.imageUrls.count ?? 0 {
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

        let imageIndex = imageVc.imageIndex
        setCaptionLabel(index: imageIndex)
        previewView.scrollToItem(atIndex: imageIndex, animated: true)
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
        // TODO: Unify with GalleryPreviewViewDataSource loading, prevent double fetching images!!
        guard galleryDataSource != nil else {
            dataCallback(nil)
            return
        }

        galleryDataSource!.fullscreenGalleryViewController(self, loadImageAtIndex: vc.imageIndex, dataCallback: dataCallback)
    }

    func title(forImageViewController vc: FullscreenImageViewController) -> String? {
        if let captions = viewModel?.imageCaptions {
            if vc.imageIndex < 0 || vc.imageIndex >= captions.count {
                return nil
            }

            return captions[vc.imageIndex]
        }

        return nil
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
    func fullscreenImageViewControllerDidBeginPanning(_ vc: FullscreenImageViewController) {
        print("begin")

        let currentIndex = currentImageViewController()?.imageIndex ?? 0
        galleryDelegate?.fullscreenGalleryViewController(self, intendsToDismissFromImageWithIndex: currentIndex)
    }

    func fullscreenImageViewControllerDidPan(_ vc: FullscreenImageViewController, withTranslation translation: CGPoint) {
        NSLog(".")

        let dist = translation.length()
        let ratio = dist / 200.0

        // Let the panning fade out to 50% opacity over 200 px
        backgroundView.alpha = 1.0 - min(0.5, ratio / 2.0)
    }

    func fullscreenImageViewControllerDidEndPan(_ vc: FullscreenImageViewController, withTranslation translation: CGPoint, velocity: CGPoint) {
        let message: String
        if translation.length() >= 200 || velocity.length() >= 100 {
            message = "Dismissing!"
            dismiss(animated: true)
        } else {
            message = "not doing anything"

            UIView.animate(withDuration: 0.3, animations: {
                self.backgroundView.alpha = 1.0
            })
        }

        print("end! t=[\(translation) [l=[\(translation.length())]], v=[\(velocity) [l=[\(velocity.length())]] \(message)")
    }
}

// MARK: - GalleryPreviewViewDataSource
extension FullscreenGalleryViewController: GalleryPreviewViewDataSource {
    func loadImage(withIndex index: Int, dataCallback: @escaping (Int, UIImage?) -> Void) {
        // TODO: Unify with FullscreenImageViewControllerDataSource loading, prevent double fetching images!!
        guard galleryDataSource != nil else {
            dataCallback(index, nil)
            return
        }

        galleryDataSource!.fullscreenGalleryViewController(self, loadImageAtIndex: index, dataCallback: { image in
            dataCallback(index, image)
        })
    }
}

// MARK: - GalleryPreviewViewDelegate
extension FullscreenGalleryViewController: GalleryPreviewViewDelegate {
    func galleryPreviewView(_ previewView: GalleryPreviewView, selectedImageAtIndex index: Int) {
        transitionToImage(atIndex: index, animated: true)
        previewView.scrollToItem(atIndex: index, animated: true)
    }
}

// MARK: - FullscreenGalleryTransitionDestinationDelegate
extension FullscreenGalleryViewController: FullscreenGalleryTransitionDestinationDelegate {
    public func viewForFullscreenGalleryTransition() -> UIView {
        guard let imageController = currentImageViewController() else {
            return view
        }

        return imageController.fullscreenImageView.imageView
    }

    public func prepareForTransition(presenting: Bool) {
        if presenting {
            backgroundView.alpha = 0.0
            if previewViewInitiallyVisible {
                setThumbnailPreviewsVisible(false, animated: false)
            }
        }
    }

    public func performTransitionAnimation(presenting: Bool) {
        if presenting {
            backgroundView.alpha = 1.0
            if previewViewInitiallyVisible {
                setThumbnailPreviewsVisible(true, animated: false)
            }
        }
    }
}
