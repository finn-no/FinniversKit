//
//  Copyright © 2020 FINN AS. All rights reserved.
//

public class MotorTransactionHeaderView: UIView {
    weak var dataSource: RemoteImageViewDataSource? {
        didSet {
            imageView.dataSource = dataSource
        }
     }

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.numberOfLines = 3
        return label
     }()

    private lazy var detailLabel: Label = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.numberOfLines = 1
        return label
    }()

     private lazy var imageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        return imageView
     }()

    private static var imageUrl = "https://images.finncdn.no/dynamic/default"
    private static var defaultImageSize: CGFloat = 64

    private var loadingColor: UIColor? = .bgSecondary
    private var fallbackImage = UIImage(named: .car)

    private var model: MotorTransactionHeaderViewModel

    public init(withAutoLayout autoLayout: Bool = false, model: MotorTransactionHeaderViewModel) {
        self.model = model
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !autoLayout
        setup()
    }

    public func loadImage() {
        guard let imagePath = model.imagePath else {
            imageView.image = fallbackImage
            return
        }

        let url = "\(MotorTransactionHeaderView.imageUrl)/\(imagePath)"
        imageView.loadImage(
            for: url,
            imageWidth: MotorTransactionHeaderView.defaultImageSize,
            loadingColor: loadingColor,
            fallbackImage: fallbackImage
        )
     }

     required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
     }

     private func setup() {
        backgroundColor = .clear

        titleLabel.text = model.title
        detailLabel.text = model.registrationNumber

        addSubview(imageView)

        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = .spacingS
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(detailLabel)
        addSubview(stackView)

        let roundedContainerView = UIView(withAutoLayout: true)
        roundedContainerView.backgroundColor = .bgSecondary
        roundedContainerView.layer.masksToBounds = true
        roundedContainerView.layer.cornerRadius = (128 / 2)
        roundedContainerView.layer.borderWidth = 0.2
        roundedContainerView.addSubview(imageView)
        addSubview(roundedContainerView)

        NSLayoutConstraint.activate([
            roundedContainerView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            roundedContainerView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            roundedContainerView.heightAnchor.constraint(equalToConstant: 128),
            roundedContainerView.widthAnchor.constraint(equalToConstant: 128),

            imageView.centerYAnchor.constraint(equalTo: roundedContainerView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: roundedContainerView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: MotorTransactionHeaderView.defaultImageSize),
            imageView.widthAnchor.constraint(equalToConstant: MotorTransactionHeaderView.defaultImageSize),

            stackView.leadingAnchor.constraint(equalTo: roundedContainerView.trailingAnchor, constant: .spacingM),
            stackView.topAnchor.constraint(equalTo: roundedContainerView.centerYAnchor, constant: -.spacingS),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingL),

            bottomAnchor.constraint(equalTo: roundedContainerView.bottomAnchor, constant: .spacingS),
         ])
     }
}
