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

    private weak var dataSource: FullscreenImageViewControllerDataSource?

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)

        // TODO!

        return imageView
    }()

    private lazy var captionLabel: Label = {
        let label = Label(style: .caption)

        // TODO!

        return label
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
        loadImage()
        captionLabel.text = dataSource?.title(forImageViewController: self)
    }

    // MARK: - Private methods

    private func loadImage() {
        dataSource?.loadImage(forImageViewController: self, dataCallback: { [weak self] image in
            self?.imageView.image = image
        })
    }
}
