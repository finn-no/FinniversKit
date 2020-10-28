import Foundation
import FinniversKit

protocol ProjectUnitCellDelegate: AnyObject {
    
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
        imageView.layer.cornerRadius = 8
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .bgSecondary
        return imageView
    }()

    private lazy var topDetailLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        return label
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyRegular, withAutoLayout: true)
        label.numberOfLines = 1
        return label
    }()

    private lazy var priceLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        return label
    }()

    private lazy var sizeLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        return label
    }()

    private lazy var bottomDetailLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        return label
    }()

    private lazy var favoriteButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.isUserInteractionEnabled = true
        button.setImage(UIImage(named: .favoriteDefault).withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(handleFavoriteButtonTap), for: .touchUpInside)
        button.tintColor = .stone
        return button
    }()

    weak var delegate: ProjectUnitCellDelegate?

    weak var remoteImageViewDataSource: RemoteImageViewDataSource? {
        didSet {
            remoteImageView.dataSource = remoteImageViewDataSource
        }
    }

    static let width: CGFloat = 300

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func horizontalStackView(with subviews: [UIView]) -> UIStackView {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .horizontal
        stackView.distribution = .equalCentering
        stackView.addArrangedSubviews(subviews)
        return stackView
    }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stackView)
        stackView.fillInSuperview()

        stackView.addArrangedSubview(remoteImageView)
        stackView.addArrangedSubview(horizontalStackView(with: [topDetailLabel, favoriteButton]))
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(horizontalStackView(with: [priceLabel, sizeLabel]))
        stackView.addArrangedSubview(bottomDetailLabel)

        NSLayoutConstraint.activate([
            remoteImageView.heightAnchor.constraint(equalToConstant: 180),
            favoriteButton.heightAnchor.constraint(equalTo: favoriteButton.widthAnchor)
        ])
    }

    func configure(with viewModel: ProjectUnitViewModel) {
        topDetailLabel.text = viewModel.topDetailText
        titleLabel.text = viewModel.title
        priceLabel.text = viewModel.price
        sizeLabel.text = viewModel.area
        bottomDetailLabel.text = viewModel.bottomDetailText // " ● "

        let fallbackImage = UIImage(named: .noImage)
        if let imageUrl = viewModel.imageUrl {
            remoteImageView.loadImage(for: imageUrl, imageWidth: ProjectUnitCell.width, loadingColor: .bgSecondary, fallbackImage: UIImage(named: .noImage))
        } else {
            remoteImageView.setImage(fallbackImage, animated: false)
        }
    }

    @objc func handleFavoriteButtonTap() {
        
    }
}
