import UIKit

public protocol FrontPageTransactionViewDelegate: AnyObject {
    func transactionViewTapped(_ transactionView: FrontPageTransactionView)
}

public class FrontPageTransactionView: UIView {
    private let imageWidth: CGFloat = 56
    private let cornerRadius: CGFloat = 8
    
    private lazy var titleLabel: UILabel = {
        let label = Label(withAutoLayout: true)
        label.font = .bodyStrong
        label.textColor = .licorice
        label.numberOfLines = 1
        label.textAlignment = .left
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = Label(withAutoLayout: true)
        label.font = .body
        label.textColor = .licorice
        label.numberOfLines = 1
        label.textAlignment = .left
        label.widthAnchor.constraint(equalToConstant: 228).isActive = true
        return label
    }()
    
    private lazy var imageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.image = UIImage(named: ImageAsset.noImage)
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.widthAnchor.constraint(equalToConstant: imageWidth).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: imageWidth).isActive = true
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView(withAutoLayout: true)
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        return stack
    }()
    
    private lazy var backgroundContainer: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .white
        view.layer.cornerRadius = cornerRadius
        return view
    }()
    
    private lazy var imageContainerView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .bgColor
        view.layer.cornerRadius = cornerRadius
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        return view
    }()
    
    private lazy var smallShadowView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.dropShadow(
            color: .shadowColor,
            opacity: 0.24,
            offset: CGSize(width: 0, height: 1),
            radius: 1
        )
        return view
    }()

    private lazy var largeShadowView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.dropShadow(
            color: .shadowColor,
            opacity: 0.16,
            offset: CGSize(width: 0, height: 1),
            radius: 5
        )
        return view
    }()
    
    private lazy var horizontalStack: UIStackView = {
        let stack = UIStackView(withAutoLayout: true)
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = .spacingXL
        return stack
    }()

    private lazy var headerLabel: UILabel = {
        let label = Label(withAutoLayout: true)
        label.font = .bodyStrong
        label.textColor = .textPrimary
        return label
    }()

    private lazy var containerStack: UIStackView = {
        let stack = UIStackView(withAutoLayout: true)
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.spacing = .spacingS
        return stack
    }()


    private(set) var viewModel: FrontPageTransactionViewModel?
    private var imageDatasource: RemoteImageViewDataSource?
    public weak var delegate: FrontPageTransactionViewDelegate?
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}

//MARK: - Private functions
extension FrontPageTransactionView {
    private func setup() {
        imageContainerView.addSubview(imageView)
        imageView.fillInSuperview()
        // addSubview(largeShadowView)
        largeShadowView.fillInSuperview()
        largeShadowView.addSubview(smallShadowView)
        smallShadowView.fillInSuperview()
        smallShadowView.addSubview(backgroundContainer)
        backgroundContainer.fillInSuperview()
        containerStack.addArrangedSubviews([headerLabel, horizontalStack])
        backgroundContainer.addSubview(horizontalStack)

        verticalStack.addArrangedSubviews([titleLabel, subtitleLabel])
        horizontalStack.addArrangedSubviews([verticalStack, imageContainerView])
        containerStack.addArrangedSubviews([headerLabel, largeShadowView])
        addSubview(containerStack)
        containerStack.fillInSuperview()
        NSLayoutConstraint.activate([
            horizontalStack.leadingAnchor.constraint(equalTo: backgroundContainer.leadingAnchor, constant: .spacingM),
            horizontalStack.topAnchor.constraint(equalTo: backgroundContainer.topAnchor, constant: .spacingM),
            horizontalStack.trailingAnchor.constraint(equalTo: backgroundContainer.trailingAnchor, constant: -.spacingM),
            horizontalStack.bottomAnchor.constraint(equalTo: backgroundContainer.bottomAnchor, constant: -.spacingM)
        ])

        backgroundContainer.backgroundColor = .bgColor

        backgroundContainer.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewTapped)))
    }

    private func loadImage() {
        guard let model = viewModel, let imageUrl = model.imageUrl else {
            imageView.setImage(UIImage(named: ImageAsset.noImage), animated: false)
            return
        }

        imageView.loadImage(for: imageUrl,
                            imageWidth: imageWidth,
                            fallbackImage: UIImage(named: ImageAsset.noImage))
    }

    @objc private func viewTapped() {
        delegate?.transactionViewTapped(self)
    }
}

// MARK: - Public API
extension FrontPageTransactionView {
    public func configure(with model: FrontPageTransactionViewModel, andImageDatasource datasource: RemoteImageViewDataSource) {
        self.viewModel = model
        self.imageDatasource = datasource
        imageView.dataSource = datasource

        titleLabel.text = model.subtitle
        subtitleLabel.text = model.title
        headerLabel.text = model.headerTitle
        loadImage()
    }
}

// MARK: - Private extensions

private extension UIColor {
    static var shadowColor: UIColor {
        return UIColor(hex: "475569")
    }

    static var bgColor: UIColor {
        return .dynamicColor(defaultColor: .milk, darkModeColor: .blueGray700)
    }
}

