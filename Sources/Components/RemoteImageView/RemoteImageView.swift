//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol RemoteImageViewDataSource: AnyObject {
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String) -> UIImage?
    func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, completion: @escaping ((UIImage?) -> Void))
    func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String)
}

public class RemoteImageView: UIImageView {

    // MARK: - Public properties

    public weak var dataSource: RemoteImageViewDataSource?

    // MARK: - Private properties

    private var imagePath: String?

    // MARK: - Public methods

    public func loadImage(for imagePath: String, loadingColor: UIColor? = nil, fallbackImage: UIImage? = nil) {
        cancelLoading()
        self.imagePath = imagePath
        guard let dataSource = dataSource else {
            setImage(fallbackImage, animated: false)
            return
        }

        if let cachedImage = dataSource.remoteImageView(self, cachedImageWithPath: imagePath) {
            setImage(cachedImage, animated: false)
        } else {
            backgroundColor = loadingColor
            dataSource.remoteImageView(self, loadImageWithPath: imagePath, completion: { [weak self] fetchedImage in
                self?.setImage(fetchedImage ?? fallbackImage, animated: false)
            })
        }
    }

    public func cancelLoading() {
        guard let currentImagePath = self.imagePath else { return }
        dataSource?.remoteImageView(self, cancelLoadingImageWithPath: currentImagePath)
    }

    public func setImage(_ image: UIImage?, animated: Bool) {
        self.image = image
        let performViewChanges = { [weak self] in
            self?.alpha = 1.0
            self?.backgroundColor = .clear
        }

        if animated {
            alpha = 0.0
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: performViewChanges)
        } else {
            performViewChanges()
        }
    }
}
