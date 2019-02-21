//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

protocol FullscreenImageViewControllerDataSource: class {
    func loadImage(forImageViewController vc: FullscreenImageViewController, dataCallback: @escaping (UIImage?) -> Void)
    func title(forImageViewController vc: FullscreenImageViewController) -> String?
    func heightForPreviewView(forImageViewController vc: FullscreenImageViewController) -> CGFloat
}

class FullscreenImageViewController: UIViewController {

    // MARK: - Private properties

    private static let zoomStep: CGFloat = 2.0

    private weak var dataSource: FullscreenImageViewControllerDataSource?

    private var shouldAdjustForPreviewView: Bool = false

    // MARK: - Public properties

    public let imageIndex: Int

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

    init(imageIndex: Int, dataSource: FullscreenImageViewControllerDataSource) {
        self.dataSource = dataSource
        self.imageIndex = imageIndex
        super.init(nibName: nil, bundle: nil)
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(fullscreenImageView)
        view.layoutIfNeeded()

        fullscreenImageView.frame = calculateImageFrame()

        loadImage()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [weak self] context in
            guard let self = self else { return }

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

}
