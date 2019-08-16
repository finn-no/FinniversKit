//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

protocol FullscreenImageViewControllerDataSource: AnyObject {
    func loadImage(forImageViewController vc: FullscreenImageViewController, dataCallback: @escaping (UIImage?) -> Void)
    func title(forImageViewController vc: FullscreenImageViewController) -> String?
    func heightForPreviewView(forImageViewController vc: FullscreenImageViewController) -> CGFloat
}

protocol FullscreenImageViewControllerDelegate: AnyObject {
    func fullscreenImageViewControllerDidBeginPan(_: FullscreenImageViewController)

    func fullscreenImageViewControllerDidPan(_: FullscreenImageViewController, withTranslation translation: CGPoint)

    /// Called by the FullscreenImageViewController when the panning gesture on the primary image view has ended.
    ///
    /// - Returns
    ///   True if the FullscreenImageViewController should animate the primary image view back into position.
    ///   False otherwise.
    func fullscreenImageViewControllerDidEndPan(_: FullscreenImageViewController, withTranslation translation: CGPoint, velocity: CGPoint) -> Bool
}

class FullscreenImageViewController: UIViewController {
    // MARK: - Public properties

    weak var dataSource: FullscreenImageViewControllerDataSource?
    weak var delegate: FullscreenImageViewControllerDelegate?

    let imageIndex: Int

    var imageViewForDismissiveAnimation: UIImageView {
        return panStateController?.panView ?? fullscreenImageView.imageView
    }

    // MARK: - Private properties

    private static let zoomStep: CGFloat = 2.0

    private var previewViewVisible: Bool = false
    private var panStateController: PanStateController?

    // MARK: - UI properties

    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        gesture.maximumNumberOfTouches = 1
        gesture.minimumNumberOfTouches = 1
        gesture.delegate = self
        return gesture
    }()

    private(set) lazy var fullscreenImageView: FullscreenImageView = {
        let imageView = FullscreenImageView(withAutoLayout: false)
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

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        panStateController = nil
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
            self.view.bounds.size = size
        })
    }

    // MARK: - Public methods

    func resetZoom() {
        fullscreenImageView.zoomScale = fullscreenImageView.minimumZoomScale
    }

    func updateLayout(withPreviewViewVisible previewViewVisible: Bool) {
        self.previewViewVisible = previewViewVisible
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
        if !previewViewVisible {
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
        switch panGesture.state {
        case .began:
            panStateController = PanStateController(from: fullscreenImageView, parentView: view)
            fullscreenImageView.minimumZoomScale /= 3.0
            delegate?.fullscreenImageViewControllerDidBeginPan(self)

        case .changed:
            guard let panStateController = panStateController else { return }

            let translation = panGesture.translation(in: view)
            let scaleFactor = 1.0 - (translation.length / (view.bounds.height * 1.5))
            panStateController.updateFrame(withTranslation: translation, scale: scaleFactor)

            delegate?.fullscreenImageViewControllerDidPan(self, withTranslation: translation)

        case .ended, .cancelled, .failed:
            let translation = panGesture.translation(in: view)
            let velocity = panGesture.velocity(in: view)
            let shouldAnimateBack = delegate?.fullscreenImageViewControllerDidEndPan(self, withTranslation: translation, velocity: velocity)

            if shouldAnimateBack ?? true {
                panStateController?.revertAnimated(withDuration: 0.4)
            }

        default:
            break
        }
    }
}

// MARK: - UIGestureRecognizerDelegate

extension FullscreenImageViewController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if fullscreenImageView.zoomScale >= fullscreenImageView.minimumZoomScale * 1.05 {
            return false
        }

        guard gestureRecognizer == panGestureRecognizer else { return false }

        let velocity = panGestureRecognizer.velocity(in: panGestureRecognizer.view)
        return velocity.length >= 1.0 && abs(velocity.y) > abs(velocity.x * 2)
    }
}

// MARK: - PanStateController

private class PanStateController {
    let initialPanFrame: CGRect
    let panView: UIImageView

    private let fullscreenImageView: FullscreenImageView
    private let parentView: UIView

    private let minimumZoomScale: CGFloat
    private let zoomScale: CGFloat
    private let originalFrame: CGRect

    private var completed = false

    init(from fullscreenImageView: FullscreenImageView, parentView: UIView) {
        self.parentView = parentView
        self.fullscreenImageView = fullscreenImageView
        let imageView = fullscreenImageView.imageView

        minimumZoomScale = fullscreenImageView.minimumZoomScale
        zoomScale = fullscreenImageView.zoomScale
        originalFrame = imageView.frame

        let pos = parentView.convert(originalFrame.origin, from: imageView)
        initialPanFrame = CGRect(x: pos.x, y: pos.y, width: originalFrame.width, height: originalFrame.height)

        panView = UIImageView(image: imageView.image)
        parentView.addSubview(panView)

        panView.frame = initialPanFrame
        imageView.isHidden = true
    }

    func updateFrame(withTranslation translation: CGPoint, scale: CGFloat) {
        guard !completed else { return }

        let size = CGSize(width: initialPanFrame.width * scale, height: initialPanFrame.height * scale)

        let scaleOffset = CGPoint(x: (initialPanFrame.width - size.width) / 2.0,
                                  y: (initialPanFrame.height - size.height) / 2.0)

        let pos = initialPanFrame.origin + translation + scaleOffset
        let frame = CGRect(x: pos.x, y: pos.y, width: size.width, height: size.height)

        panView.frame = frame
    }

    func revertAnimated(withDuration duration: TimeInterval) {
        guard !completed else { return }
        completed = true

        fullscreenImageView.minimumZoomScale = minimumZoomScale
        fullscreenImageView.zoomScale = zoomScale

        let endFrame = parentView.convert(originalFrame, from: fullscreenImageView)

        UIView.animate(withDuration: duration, animations: {
            self.panView.frame = endFrame
        }, completion: { _ in
            self.panView.removeFromSuperview()
            self.fullscreenImageView.imageView.isHidden = false
        })
    }
}
