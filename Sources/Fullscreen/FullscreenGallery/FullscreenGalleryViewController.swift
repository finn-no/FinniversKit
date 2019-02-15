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

    private var viewModel: FullscreenGalleryViewModel?

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

    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.delegate = self
        self.dataSource = self
    }

    // MARK : - Lifecycle

    public override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = galleryDataSource?.modelForFullscreenGalleryViewController(self)
        let initialImageIndex = galleryDataSource?.initialImageIndexForFullscreenGalleryViewController(self) ?? 0

        if let imageController = imageViewController(forIndex: initialImageIndex) {
            setViewControllers([imageController], direction: .forward, animated: false)
        }
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

        return FullscreenImageViewController(imageIndex: index, dataSource: self)
    }
}

// MARK: - UIPageViewControllerDelegate
extension FullscreenGalleryViewController: UIPageViewControllerDelegate {

}

// MARK: - FullscreenImageViewControllerDataSource
extension FullscreenGalleryViewController: FullscreenImageViewControllerDataSource {
    func loadImage(forImageViewController vc: FullscreenImageViewController, dataCallback: @escaping (UIImage?) -> Void) {
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
}
