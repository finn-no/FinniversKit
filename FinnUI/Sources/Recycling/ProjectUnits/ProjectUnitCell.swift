//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Foundation
import FinniversKit

protocol ProjectUnitCellDelegate: AnyObject {
    func projectUnitCell(_ projectUnitCell: ProjectUnitCell, didTapFavoriteButton button: UIButton)
}

class ProjectUnitCell: UICollectionViewCell {

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        return stackView
    }()

    private lazy var remoteImageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = .spacingS
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .bgSecondary
        return imageView
    }()

    private lazy var topDetailLabel = Label(style: .detail, withAutoLayout: true)
    private lazy var titleLabel = Label(style: .bodyRegular, withAutoLayout: true)
    private lazy var priceLabel = Label(style: .bodyStrong, withAutoLayout: true)
    private lazy var areaLabel = Label(style: .bodyStrong, withAutoLayout: true)
    private lazy var bottomDetailLabel = Label(style: .detail, withAutoLayout: true)

    private lazy var favoriteButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(handleFavoriteButtonTap), for: .touchUpInside)
        button.tintColor = .stone
        return button
    }()

    // MARK: - Internal properties

    static let width: CGFloat = 290
    static let height: CGFloat = 280

    var isFavorite: Bool = false {
        didSet {
            updateFavoriteButton(isFavorite: isFavorite)
        }
    }

    weak var delegate: ProjectUnitCellDelegate?

    weak var remoteImageViewDataSource: RemoteImageViewDataSource? {
        didSet {
            remoteImageView.dataSource = remoteImageViewDataSource
        }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        stackView.fillInSuperview()

        let topStackView = createStackView(withLeftColumn: topDetailLabel, rightColumn: favoriteButton)
        let bottomStackView = createStackView(withLeftColumn: priceLabel, rightColumn: areaLabel)

        stackView.addArrangedSubview(remoteImageView)
        stackView.addArrangedSubview(topStackView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(bottomStackView)
        stackView.addArrangedSubview(bottomDetailLabel)

        NSLayoutConstraint.activate([
            remoteImageView.heightAnchor.constraint(equalToConstant: 190),
            favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.widthAnchor)
        ])
    }

    private func createStackView(withLeftColumn leftColumn: UIView, rightColumn: UIView) -> UIStackView {
        let stackView = UIStackView(axis: .horizontal, withAutoLayout: true)
        stackView.distribution = .equalSpacing
        stackView.addArrangedSubviews([leftColumn, rightColumn])
        return stackView
    }

    // MARK: - Internal methods

    func configure(with viewModel: ProjectUnitViewModel) {
        topDetailLabel.text = viewModel.topDetailText
        titleLabel.text = viewModel.title
        priceLabel.text = viewModel.price
        areaLabel.text = viewModel.area
        bottomDetailLabel.text = viewModel.bottomDetailText

        let fallbackImage = UIImage(named: .noImage)
        if let imageUrl = viewModel.imageUrl {
            remoteImageView.loadImage(for: imageUrl, imageWidth: ProjectUnitCell.width, loadingColor: .bgSecondary, fallbackImage: fallbackImage)
        } else {
            remoteImageView.setImage(fallbackImage, animated: false)
        }
    }

    // MARK: - Private methods

    private func updateFavoriteButton(isFavorite: Bool) {
        let favoriteImage = isFavorite ? UIImage(named: .favoriteActive) : UIImage(named: .favoriteDefault).withRenderingMode(.alwaysTemplate)
        favoriteButton.setImage(favoriteImage, for: .normal)
    }

    @objc private func handleFavoriteButtonTap() {
        delegate?.projectUnitCell(self, didTapFavoriteButton: favoriteButton)
    }
}
