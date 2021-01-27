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
       imageView.clipsToBounds = true
       imageView.contentMode = .scaleAspectFill
       return imageView
    }()

    private lazy var roundedContainerImageView: UIView = {
        let roundedContainerView = UIView(withAutoLayout: true)
        roundedContainerView.backgroundColor = .bgSecondary
        roundedContainerView.contentMode = .center
        roundedContainerView.layer.masksToBounds = true
        roundedContainerView.layer.cornerRadius = (imageWidth / 2)
        roundedContainerView.layer.borderWidth = 0.2
        roundedContainerView.addSubview(imageView)
        return roundedContainerView
    }()

    private static var imageUrl = "https://images.finncdn.no/dynamic/default"

    private let imageWidth = CGFloat(128)
    private let loadingColor: UIColor? = .bgSecondary
    private let fallbackImage = UIImage(named: .car)

    private var model: MotorTransactionHeaderViewModel

    public init(withAutoLayout autoLayout: Bool = false, model: MotorTransactionHeaderViewModel) {
        self.model = model
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !autoLayout
        setup()
    }

    public func loadImage() {
        guard let imagePath = model.imagePath, imagePath != "" else {
            imageView.contentMode = .scaleAspectFit
            imageView.image = fallbackImage
            return
        }

        let url = "\(MotorTransactionHeaderView.imageUrl)/\(imagePath)"
        imageView.loadImage(
            for: url,
            imageWidth: imageWidth,
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

        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillProportionally
        stackView.spacing = .spacingS
        stackView.addArrangedSubviews([titleLabel, detailLabel])

        addSubview(stackView)
        addSubview(roundedContainerImageView)

        NSLayoutConstraint.activate([
            roundedContainerImageView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            roundedContainerImageView.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            roundedContainerImageView.heightAnchor.constraint(equalToConstant: imageWidth),
            roundedContainerImageView.widthAnchor.constraint(equalToConstant: imageWidth),

            imageView.centerYAnchor.constraint(equalTo: roundedContainerImageView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: roundedContainerImageView.centerXAnchor),
            imageView.heightAnchor.constraint(equalToConstant: imageWidth),
            imageView.widthAnchor.constraint(equalToConstant: imageWidth),

            stackView.leadingAnchor.constraint(equalTo: roundedContainerImageView.trailingAnchor, constant: .spacingM),
            stackView.topAnchor.constraint(equalTo: roundedContainerImageView.centerYAnchor, constant: -.spacingS),
            stackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.spacingL),

            bottomAnchor.constraint(equalTo: roundedContainerImageView.bottomAnchor, constant: .spacingS),
         ])
     }
}
