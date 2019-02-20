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

}

public class FullscreenGalleryViewController: UIPageViewController {

    // MARK: - Private properties

    private let captionFadeDuration = 0.2
    private let dismissButtonTitle = "Ferdig"
    private var viewModel: FullscreenGalleryViewModel?
    private var previewViewVisible: Bool
    private var hasPerformedInitialViewLayout: Bool = false

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
        let button = Button(style: .default)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        button.backgroundColor = .clear
        button.setTitle(dismissButtonTitle, for: .normal)
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
        return previewView.topAnchor.constraint(equalTo: view.bottomAnchor)
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

    // MARK: - Public properties

    public weak var galleryDataSource: FullscreenGalleryViewControllerDataSource?
    public weak var galleryDelegate: FullscreenGalleryViewControllerDelegate?

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented: init(coder:)")
    }

    public override init(transitionStyle style: TransitionStyle, navigationOrientation: NavigationOrientation, options: [OptionsKey: Any]?) {
        fatalError("not implemented: init(transitionStyle:navigationOrientation:options:)")
    }

    public init(thumbnailsInitiallyVisible previewVisible: Bool) {
        self.previewViewVisible = previewVisible
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.delegate = self
        self.dataSource = self
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

        view.backgroundColor = .black
        view.addSubview(captionLabel)

        view.addSubview(dismissButton)
        view.addSubview(previewView)
        view.addGestureRecognizer(singleTapGestureRecognizer)

        let initialPreviewViewVisibilityConstraint = previewViewVisible
            ? previewViewVisibleConstraint
            : previewViewHiddenConstraint

        NSLayoutConstraint.activate([
            captionLabel.centerXAnchor.constraint(equalTo: safeLayoutGuide.centerXAnchor),
            captionLabel.widthAnchor.constraint(lessThanOrEqualTo: safeLayoutGuide.widthAnchor, constant: -(2 * .mediumLargeSpacing)),
            captionLabel.bottomAnchor.constraint(lessThanOrEqualTo: safeLayoutGuide.bottomAnchor, constant: -.mediumSpacing),
            captionLabel.bottomAnchor.constraint(lessThanOrEqualTo: previewView.topAnchor, constant: -.mediumSpacing),

            dismissButton.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor, constant: -.mediumLargeSpacing),
            dismissButton.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor, constant: .mediumLargeSpacing),

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

        if !hasPerformedInitialViewLayout {
            if let currentIndex = (viewControllers?.first as? FullscreenImageViewController)?.imageIndex {
                // Without the layoutIfNeeded()-call, it appears to be quite random whether the
                // scroll-call will have any effect or not.
                previewView.layoutIfNeeded()
                previewView.scrollToItem(atIndex: currentIndex, animated: false)
            }
        }

        hasPerformedInitialViewLayout = true
    }

    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        previewView.superviewWillTransition(to: size)
    }

    // MARK: - View interactions

    @objc private func dismissButtonTapped() {
        dismiss(animated: true)
    }

    @objc private func onSingleTap(_ gestureRecognizer: UIGestureRecognizer) {
        setThumbnailPreviewsVisible(!previewViewVisible, animated: true)
    }

    // MARK: - View modifications

    private func transitionToImage(atIndex index: Int, animated: Bool) {
        if let currentIndex = (viewControllers?.first as? FullscreenImageViewController)?.imageIndex {
            guard currentIndex != index else {
                return
            }
        }

        setCaptionLabel(index: index)

        if let newController = imageViewController(forIndex: index) {
            if animated, let currentController = viewControllers?.first as? FullscreenImageViewController {
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

        let vc = FullscreenImageViewController(imageIndex: index, dataSource: self)
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
        let previewHeight = previewView.frame.height
        var bottomInset: CGFloat = 0.0

        if #available(iOS 11.0, *) {
            bottomInset = view.safeAreaInsets.bottom
        }

        return previewHeight + bottomInset
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
