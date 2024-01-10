//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol RemoteImageViewDataSource: AnyObject {
    @MainActor func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage?
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
    private var isLoadingImage = false

    // MARK: - Public methods

    public func loadImage(
        for imagePath: String,
        imageWidth: CGFloat,
        loadingColor: UIColor? = nil,
        loadedColor: UIColor = .clear,
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
            setImage(modify?(cachedImage) ?? cachedImage, animated: false, backgroundColor: loadedColor)
        } else {
            isLoadingImage = true
            backgroundColor = loadingColor
            dataSource.remoteImageView(self, loadImageWithPath: imagePath, imageWidth: imageWidth, completion: { [weak self] fetchedImage in
                guard imagePath == self?.imagePath else {
                    return
                }

                let image = modify?(fetchedImage) ?? fetchedImage
                self?.setImage(image ?? fallbackImage, animated: false, backgroundColor: loadedColor)
                self?.isLoadingImage = false
            })
        }
    }

    public func cancelLoading() {
        guard isLoadingImage, let imagePath, let imageWidth else { return }
        dataSource?.remoteImageView(self, cancelLoadingImageWithPath: imagePath, imageWidth: imageWidth)
        isLoadingImage = false
    }

    public func setImage(_ image: UIImage?, animated: Bool, backgroundColor: UIColor = .clear) {
        let performViewChanges = { [weak self] in
            guard let self = self else { return }

            self.image = image
            self.alpha = 1.0
            self.backgroundColor = backgroundColor
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
