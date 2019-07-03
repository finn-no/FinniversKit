//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

final class RemoteImageTableViewCell: BasicTableViewCell {
    private lazy var remoteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var remoteImageWidthConstraint = stackView.widthAnchor.constraint(equalToConstant: 40)

    // MARK: - Setup

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Public methods

    public override func prepareForReuse() {
        super.prepareForReuse()
        remoteImageView.image = nil
    }

    public func configure(with viewModel: RemoteImageTableViewCellViewModel) {
        super.configure(with: viewModel)

        selectionStyle = .default
        remoteImageView.layer.cornerRadius = viewModel.cornerRadius
        remoteImageWidthConstraint.constant = viewModel.imageSize
        separatorInset = .leadingInset(.mediumLargeSpacing * 2 + viewModel.imageSize)
        setNeedsLayout()
    }

    // MARK: - Private methods

    private func setup() {
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
