//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Bootstrap

public class RemoteImageTableViewCell: BasicTableViewCell {
    /// A data source for the loading of the image
    public weak var dataSource: RemoteImageViewDataSource? {
        didSet {
            remoteImageView.dataSource = dataSource
        }
    }
    /// The loading color is used to fill the image view while we load the image.
    public var loadingColor: UIColor?
    public var isLoadingEnabled = true
    public var fallbackImage: UIImage = UIImage(named: .noImage)

    private var viewModel: RemoteImageTableViewCellViewModel?

    private(set) lazy var remoteImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var remoteImageWidthConstraint = remoteImageView.widthAnchor.constraint(equalToConstant: 40)

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
        accessibilityLabel = ""

        remoteImageView.cancelLoading()
        remoteImageView.setImage(nil, animated: false)
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
        guard let viewModel = viewModel, let imagePath = viewModel.imagePath, isLoadingEnabled else {
            remoteImageView.setImage(fallbackImage, animated: false)
            return
        }

        remoteImageView.loadImage(for: imagePath, imageWidth: viewModel.imageViewWidth, loadingColor: loadingColor, fallbackImage: fallbackImage)
    }

    // MARK: - Private

    private func setup() {
        isAccessibilityElement = true
        backgroundColor = .bgPrimary
        contentView.addSubview(remoteImageView)

        stackViewLeadingAnchorConstraint.isActive = false

        NSLayoutConstraint.activate([
            remoteImageWidthConstraint,
            remoteImageView.heightAnchor.constraint(equalTo: remoteImageView.widthAnchor),
            remoteImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: .mediumLargeSpacing),
            remoteImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            stackView.leadingAnchor.constraint(equalTo: remoteImageView.trailingAnchor, constant: .mediumLargeSpacing)
        ])
    }
}
