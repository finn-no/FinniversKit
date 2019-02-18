//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

class GalleryPreviewCell: UICollectionViewCell {

    // MARK: - Private properties

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
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

    private func setup() {
        contentView.addSubview(imageView)
        imageView.fillInSuperview()
    }

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }

    // MARK: - Public methods

    func configure(withImage image: UIImage?) {
        imageView.image = image
    }
}
