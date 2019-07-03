//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol RemoteImageTableViewCellDataSource: class {
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

public final class RemoteImageTableViewCell: BasicTableViewCell {
    /// A data source for the loading of the image
    public weak var dataSource: RemoteImageTableViewCellDataSource?
    /// The loading color is used to fill the image view while we load the image.
    public var loadingColor: UIColor?

    private var viewModel: RemoteImageTableViewCellViewModel?
    private lazy var remoteImageWidthConstraint = stackView.widthAnchor.constraint(equalToConstant: 40)

    private lazy var remoteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

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
        separatorInset = .leadingInset(.mediumLargeSpacing * 2 + viewModel.imageSize)

        remoteImageView.layer.cornerRadius = viewModel.cornerRadius
        remoteImageWidthConstraint.constant = viewModel.imageSize

        setNeedsLayout()
    }

    public func loadImage() {
        guard let viewModel = viewModel, let dataSource = dataSource, viewModel.imageUrl != nil else {
            loadingColor = .clear
            remoteImageView.image = defaultImage
            return
        }

        remoteImageView.backgroundColor = loadingColor

        dataSource.remoteImageTableViewCell(self, loadImageForModel: viewModel) { [weak self] image in
            self?.remoteImageView.backgroundColor = .clear
            self?.remoteImageView.image = image ?? self?.defaultImage
        }
    }

    // MARK: - Private

    private func setup() {
        isAccessibilityElement = true
        backgroundColor = .milk
        contentView.addSubview(remoteImageView)

        stackViewLeadingAnchorConstraint.isActive = false

        NSLayoutConstraint.activate([
            remoteImageView.widthAnchor.constraint(equalToConstant: 40),
            remoteImageView.heightAnchor.constraint(equalTo: remoteImageView.widthAnchor),
            remoteImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            remoteImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            stackView.leadingAnchor.constraint(equalTo: remoteImageView.trailingAnchor, constant: .mediumSpacing)
        ])
    }
}
