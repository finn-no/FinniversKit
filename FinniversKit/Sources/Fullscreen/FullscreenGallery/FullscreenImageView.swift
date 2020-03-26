//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

class FullscreenImageView: UIScrollView {

    // MARK: - Public properties

    var image: UIImage? {
        didSet {
            imageView.image = image
            recalculateLimitsAndBounds(forSize: bounds.size)
        }
    }

    // MARK: - Private properties

    private static let zoomStep: CGFloat = 2.0

    // MARK: - UI properties

    private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.clipsToBounds = false
        return imageView
    }()

    private lazy var doubleTapRecognizer: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onDoubleTap))
        recognizer.numberOfTapsRequired = 2
        return recognizer
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

    convenience init() {
        self.init(frame: .zero)
    }

    private func setup() {
        delegate = self
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false

        addGestureRecognizer(doubleTapRecognizer)

        addSubview(imageView)
        imageView.fillInSuperview()
    }

    // MARK: - Public methods

    func superviewWillTransition(to size: CGSize) {
        recalculateLimitsAndBounds(forSize: size)
    }

    func recalculateLimitsAndBounds() {
        recalculateLimitsAndBounds(forSize: bounds.size)
    }

    // MARK: - Private methods

    private func recalculateLimitsAndBounds(forSize size: CGSize) {
        calculateZoomLimits(forViewSize: size)
        adjustImageInsets(forViewSize: size)
    }

    private func calculateZoomLimits(forViewSize viewSize: CGSize) {
        guard let image = self.image else {
            return
        }

        let constrainedImageSize: CGFloat
        let constrainedScreenSize: CGFloat

        let screenAspectRatio = viewSize.width / viewSize.height
        let imageAspectRatio = image.size.width / image.size.height

        if screenAspectRatio < imageAspectRatio {
            constrainedImageSize = image.size.width
            constrainedScreenSize = viewSize.width
        } else {
            constrainedImageSize = image.size.height
            constrainedScreenSize = viewSize.height
        }

        let minZoomScale = constrainedScreenSize / constrainedImageSize
        let maxZoomScale = max(2.5 * minZoomScale, (2.0 * constrainedImageSize) / constrainedScreenSize)

        maximumZoomScale = maxZoomScale
        minimumZoomScale = minZoomScale
        zoomScale = minZoomScale

        // The contentSize will be set automatically at a later point in time, but in order
        // to be able to work with it immediately we need to set it manually.
        contentSize = CGSize(width: minZoomScale * image.size.width, height: minZoomScale * image.size.height)
    }

    private func adjustImageInsets(forViewSize viewSize: CGSize) {
        let offsetX = max((viewSize.width - contentSize.width) * 0.5, 0)
        let offsetY = max((viewSize.height - contentSize.height) * 0.5, 0)
        contentInset = UIEdgeInsets(top: offsetY, leading: offsetX, bottom: 0, trailing: 0)
    }
}

// MARK: - Double tap handling

extension FullscreenImageView {
    @objc private func onDoubleTap(_ recognizer: UIGestureRecognizer) {
        // When double tapping, only alternate between 1x and 2x. Further zooming may be permitted,
        // but that has to be done explicitly. Double tapping an already zoomed in image should always
        // result in zooming back out to 1x.
        var newZoom: CGFloat

        // Consider the user zoomed in if the view is zoomed in more than 10%.
        let zoomThresholdFactor = CGFloat(1.10)
        let isZoomedIn = (zoomScale >= minimumZoomScale * zoomThresholdFactor)

        if isZoomedIn {
            newZoom = minimumZoomScale
        } else {
            newZoom = zoomScale * FullscreenImageView.zoomStep
        }

        var center = recognizer.location(in: recognizer.view)
        center.x /= zoomScale
        center.y /= zoomScale

        let newRect = zoomRect(forScale: newZoom, withCenter: center)
        zoom(to: newRect, animated: true)
    }

    private func zoomRect(forScale scale: CGFloat, withCenter center: CGPoint) -> CGRect {
        var zoomRect = CGRect()

        zoomRect.size.height = frame.size.height / scale
        zoomRect.size.width = frame.size.width  / scale

        zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)

        return zoomRect
    }
}

extension FullscreenImageView: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        adjustImageInsets(forViewSize: bounds.size)
    }
}
