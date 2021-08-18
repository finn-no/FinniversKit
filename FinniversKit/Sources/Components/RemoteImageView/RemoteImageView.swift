//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol RemoteImageViewDataSource: AnyObject {
    func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage?
    func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void))
    func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat)
}

public protocol RemoteImageViewDelegate: AnyObject {
    func remoteImageViewDidSetImage(_ view: RemoteImageView)
}

public class RemoteImageView: UIImageView {

    // MARK: - Public properties

    public weak var dataSource: RemoteImageViewDataSource?
    public weak var delegate: RemoteImageViewDelegate?

    // MARK: - Private properties

    private var imagePath: String?
    private var imageWidth: CGFloat?

    // MARK: - Public methods

    public func loadImage(
        for imagePath: String,
        imageWidth: CGFloat,
        loadingColor: UIColor? = nil,
        fallbackImage: UIImage? = nil,
        modify: ((UIImage?) -> UIImage?)? = nil
    ) {
        cancelLoading()
        self.imagePath = imagePath
        self.imageWidth = imageWidth
        guard let dataSource = dataSource else {
            setImage(fallbackImage, animated: false)
            return
        }

        if let cachedImage = dataSource.remoteImageView(self, cachedImageWithPath: imagePath, imageWidth: imageWidth) {
            setImage(modify?(cachedImage) ?? cachedImage, animated: false)
        } else {
            backgroundColor = loadingColor
            dataSource.remoteImageView(self, loadImageWithPath: imagePath, imageWidth: imageWidth, completion: { [weak self] fetchedImage in
                let image = modify?(fetchedImage) ?? fetchedImage
                self?.setImage(image ?? fallbackImage, animated: false)
            })
        }
    }

    public func cancelLoading() {
        guard let currentImagePath = self.imagePath, let imageWidth = imageWidth else { return }
        dataSource?.remoteImageView(self, cancelLoadingImageWithPath: currentImagePath, imageWidth: imageWidth)
    }

    public func setImage(_ image: UIImage?, animated: Bool) {
        let performViewChanges = { [weak self] in
            guard let self = self else { return }

            self.image = image
            self.alpha = 1.0
            self.backgroundColor = .clear
            self.delegate?.remoteImageViewDidSetImage(self)
        }

        if animated {
            alpha = 0.0
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: performViewChanges)
        } else {
            performViewChanges()
        }
    }
}
