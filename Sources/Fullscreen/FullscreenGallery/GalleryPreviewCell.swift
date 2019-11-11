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
        imageView.layer.borderColor = .selectedImageBorder
        imageView.layer.borderWidth = 0.0
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
        clipsToBounds = false
        backgroundColor = .clear
        contentView.backgroundColor = .clear

        contentView.addSubview(imageView)
        imageView.fillInSuperview()
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 5

        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.main.scale
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.layer.borderWidth = 0.0
    }

    // MARK: - Public methods

    func configure(withImage image: UIImage?) {
        imageView.image = image
    }

    func border(isVisible: Bool) {
        imageView.layer.borderWidth = isVisible ? 2.0 : 0.0
    }
}

// MARK: - Private extensions

private extension CGColor {
    class var selectedImageBorder: CGColor {
        return .milk
    }
}
