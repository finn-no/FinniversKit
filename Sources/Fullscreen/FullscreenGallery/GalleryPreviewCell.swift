//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

class GalleryPreviewCell: UICollectionViewCell {

    // MARK: - Private properties

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .clear
        imageView.clipsToBounds = true
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
        backgroundColor = .clear
        contentView.backgroundColor = .clear

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
