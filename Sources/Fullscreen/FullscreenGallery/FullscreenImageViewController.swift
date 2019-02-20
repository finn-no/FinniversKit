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

    private lazy var imageView: FullscreenImageView = {
        let imageView = FullscreenImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
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

        view.addSubview(imageView)
        imageView.fillInSuperview()

        loadImage()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { [weak self] context in
            self?.imageView.superviewWillTransition(to: size)
        })
    }

    private func loadImage() {
        dataSource?.loadImage(forImageViewController: self, dataCallback: { [weak self] image in
            self?.imageView.image = image
        })
    }

}
