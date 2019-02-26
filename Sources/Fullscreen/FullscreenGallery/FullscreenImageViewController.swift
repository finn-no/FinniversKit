//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

protocol FullscreenImageViewControllerDataSource: class {
    func loadImage(forImageViewController vc: FullscreenImageViewController, dataCallback: @escaping (UIImage?) -> Void)
    func title(forImageViewController vc: FullscreenImageViewController) -> String?
    func heightForPreviewView(forImageViewController vc: FullscreenImageViewController) -> CGFloat
}

protocol FullscreenImageViewControllerDelegate: class {
    func fullscreenImageViewControllerDidBeginPanning(_ vc: FullscreenImageViewController)
    func fullscreenImageViewControllerDidPan(_ vc: FullscreenImageViewController, withTranslation translation: CGPoint)

    /// Called by the FullscreenImageViewController when the panning gesture on the primary image view has ended.
    ///
    /// - Returns
    ///   True if the FullscreenImageViewController should animate the primary image view back into position.
    ///   False otherwise.
    func fullscreenImageViewControllerDidEndPan(_ vc: FullscreenImageViewController, withTranslation translation: CGPoint, velocity: CGPoint) -> Bool
}

private class ScrollViewPrePanState {
    let minimumZoomScale: CGFloat
    let zoomScale: CGFloat
    let frame: CGRect

    init(from: UIScrollView) {
        minimumZoomScale = from.minimumZoomScale
        zoomScale = from.zoomScale
        frame = from.frame
    }

    func apply(onScrollView scrollView: UIScrollView) {
        scrollView.minimumZoomScale = minimumZoomScale
        scrollView.zoomScale = zoomScale
        scrollView.frame = frame
    }
}

class FullscreenImageViewController: UIViewController, UIGestureRecognizerDelegate {
    // MARK: - Public properties

    public weak var dataSource: FullscreenImageViewControllerDataSource?
    public weak var delegate: FullscreenImageViewControllerDelegate?

    public let imageIndex: Int

    // MARK: - Private properties

    private static let zoomStep: CGFloat = 2.0

    private var shouldAdjustForPreviewView: Bool = false
    private var prePanState: ScrollViewPrePanState?

    // MARK: - UI properties

    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        gesture.maximumNumberOfTouches = 1
        gesture.minimumNumberOfTouches = 1
        gesture.delegate = self
        return gesture
    }()

    private(set) lazy var fullscreenImageView: FullscreenImageView = {
        let imageView = FullscreenImageView()
        imageView.clipsToBounds = false
        return imageView
    }()

    // MARK: - Init

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        fatalError("not implemented: init(nibName:bundle:)")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("not implemented: init(coder:)")
    }

    init(imageIndex: Int) {
        self.imageIndex = imageIndex
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(fullscreenImageView)
        view.layoutIfNeeded()

        fullscreenImageView.frame = calculateImageFrame()
        fullscreenImageView.addGestureRecognizer(panGestureRecognizer)

        loadImage()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [weak self] _ in
            guard let self = self else {
                return
            }

            let newFrame = self.calculateImageFrame(fromSize: size)
            self.fullscreenImageView.superviewWillTransition(to: newFrame.size)
            self.fullscreenImageView.frame = newFrame
        })
    }

    // MARK: - Public methods

    public func updateLayout(withPreviewViewVisible previewVisible: Bool) {
        shouldAdjustForPreviewView = previewVisible
        fullscreenImageView.frame = calculateImageFrame()
        fullscreenImageView.recalculateLimitsAndBounds()
    }

    // MARK: - Private methods

    private func calculateImageFrame() -> CGRect {
        return calculateImageFrame(fromSize: view.bounds.size)
    }

    private func calculateImageFrame(fromSize size: CGSize) -> CGRect {
        let size = adjustSizeToOffsetPreviewIfNeeded(size)
        return CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }

    private func adjustSizeToOffsetPreviewIfNeeded(_ size: CGSize) -> CGSize {
        if !shouldAdjustForPreviewView {
            return size
        }

        let previewHeight = dataSource?.heightForPreviewView(forImageViewController: self) ?? 0.0
        return CGSize(width: size.width, height: size.height - previewHeight)
    }

    private func loadImage() {
        dataSource?.loadImage(forImageViewController: self, dataCallback: { [weak self] image in
            self?.fullscreenImageView.layoutIfNeeded()
            self?.fullscreenImageView.image = image
        })
    }

    // MARK: - Pan gesture handling

    @objc private func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        let animateBack = {
            UIView.animate(withDuration: 0.4, animations: {
                self.prePanState?.apply(onScrollView: self.fullscreenImageView)
            })
        }

        switch panGesture.state {
        case .began:
            prePanState = ScrollViewPrePanState(from: fullscreenImageView)
            fullscreenImageView.minimumZoomScale /= 3.0
            delegate?.fullscreenImageViewControllerDidBeginPanning(self)

        case .changed:
            guard let prePanState = prePanState else { return }

            let translation = panGesture.translation(in: fullscreenImageView)

            let size = fullscreenImageView.frame.size
            let pos = prePanState.frame.origin + translation
            fullscreenImageView.frame = CGRect(x: pos.x, y: pos.y, width: size.width, height: size.height)

            let scaleFactor = 1.0 - (translation.length() / (view.bounds.height * 1.5))
            fullscreenImageView.zoomScale = prePanState.zoomScale * scaleFactor

            delegate?.fullscreenImageViewControllerDidPan(self, withTranslation: translation)

        case .ended, .cancelled, .failed:
            let translation = panGesture.translation(in: fullscreenImageView)
            let velocity = panGesture.velocity(in: fullscreenImageView)
            let shouldAnimateBack = delegate?.fullscreenImageViewControllerDidEndPan(self, withTranslation: translation, velocity: velocity)

            if shouldAnimateBack ?? true {
                animateBack()
            }

        default:
            break
        }
    }

    // MARK: - UIGestureRecognizerDelegate

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if fullscreenImageView.zoomScale >= fullscreenImageView.minimumZoomScale * 1.05 {
            return false
        }

        guard gestureRecognizer == panGestureRecognizer else { return false }

        let translation = panGestureRecognizer.translation(in: panGestureRecognizer.view)
        return abs(translation.x) * 2 <= abs(translation.y)
    }
}
