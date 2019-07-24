//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol RemoteImageTableViewCellDataSource: AnyObject {
    func remoteImageTableViewCell(
        _ cell: RemoteImageTableViewCell,
        cachedImageForModel model: RemoteImageTableViewCellViewModel
    ) -> UIImage?

    func remoteImageTableViewCell(
        _ cell: RemoteImageTableViewCell,
        loadImageForModel model: RemoteImageTableViewCellViewModel,
        completion: @escaping ((UIImage?) -> Void)
    )

    func remoteImageTableViewCell(
        _ cell: RemoteImageTableViewCell,
        cancelLoadingImageForModel model: RemoteImageTableViewCellViewModel
    )
}

public class RemoteImageTableViewCell: BasicTableViewCell {
    /// A data source for the loading of the image
    public weak var dataSource: RemoteImageTableViewCellDataSource?
    /// The loading color is used to fill the image view while we load the image.
    public var loadingColor: UIColor?
    private var viewModel: RemoteImageTableViewCellViewModel?

    private lazy var remoteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    public lazy var remoteImageLeadingConstraint = remoteImageView.leadingAnchor.constraint(
        equalTo: contentView.leadingAnchor,
        constant: .mediumLargeSpacing
    )

    private lazy var remoteImageWidthConstraint = remoteImageView.widthAnchor.constraint(equalToConstant: 40)

    private var defaultImage: UIImage? {
        return UIImage(named: .noImage)
    }

    // MARK: - Init

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Overrides

    public override func prepareForReuse() {
        super.prepareForReuse()
        remoteImageView.image = nil
        accessibilityLabel = ""

        if let viewModel = viewModel {
            dataSource?.remoteImageTableViewCell(self, cancelLoadingImageForModel: viewModel)
        }
    }

    // MARK: - Public

    public func configure(with viewModel: RemoteImageTableViewCellViewModel) {
        super.configure(with: viewModel)
        self.viewModel = viewModel

        selectionStyle = .default
        separatorInset = .leadingInset(.mediumLargeSpacing * 2 + viewModel.imageViewWidth)

        remoteImageView.layer.cornerRadius = viewModel.cornerRadius
        remoteImageWidthConstraint.constant = viewModel.imageViewWidth

        setNeedsLayout()
    }

    public func loadImage() {
        guard let viewModel = viewModel, let dataSource = dataSource, viewModel.imagePath != nil else {
            setImage(defaultImage, animated: false)
            return
        }

        if let cachedImage = dataSource.remoteImageTableViewCell(self, cachedImageForModel: viewModel) {
            setImage(cachedImage, animated: false)
        } else {
            remoteImageView.backgroundColor = loadingColor

            dataSource.remoteImageTableViewCell(self, loadImageForModel: viewModel) { [weak self] image in
                self?.setImage( image ?? self?.defaultImage, animated: false)
            }
        }
    }

    // MARK: - Private

    private func setup() {
        isAccessibilityElement = true
        backgroundColor = .milk
        contentView.addSubview(remoteImageView)

        stackViewLeadingAnchorConstraint.isActive = false

        NSLayoutConstraint.activate([
            remoteImageLeadingConstraint,
            remoteImageWidthConstraint,
            remoteImageView.heightAnchor.constraint(equalTo: remoteImageView.widthAnchor),
            remoteImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            stackView.leadingAnchor.constraint(equalTo: remoteImageView.trailingAnchor, constant: .mediumLargeSpacing)
        ])
    }

    private func setImage(_ image: UIImage?, animated: Bool) {
        remoteImageView.image = image

        let performViewChanges = { [weak self] in
            self?.remoteImageView.alpha = 1.0
            self?.remoteImageView.backgroundColor = .clear
        }

        if animated {
            remoteImageView.alpha = 0.0
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: performViewChanges)
        } else {
            performViewChanges()
        }
    }
}
