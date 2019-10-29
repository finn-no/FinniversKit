//
//  Copyright © 2019 FINN AS. All rights reserved.
//

class AdConfirmationObjectView: UIView {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        return imageView
    }()

    private lazy var checkmarkView: RoundedImageView = {
        let checkmarkView = RoundedImageView(withAutoLayout: true)
        return checkmarkView
    }()

    private lazy var titleLabel: Label = {
        let titleLabel = Label(style: .title3Strong, withAutoLayout: true)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        return titleLabel
    }()

    private lazy var bodyLabel: Label = {
        let bodyLabel = Label(style: .caption, withAutoLayout: true)
        bodyLabel.numberOfLines = 0
        bodyLabel.textAlignment = .center
        return bodyLabel
    }()

    public var model: AdConfirmationObjectViewModel? {
        didSet {
            titleLabel.text = model?.title
            bodyLabel.text = model?.body
        }
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        backgroundColor = .bgPrimary
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AdConfirmationObjectView {
    func setup() {
        addSubview(imageView)
        addSubview(checkmarkView)
        addSubview(titleLabel)
        addSubview(bodyLabel)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
            imageView.widthAnchor.constraint(equalToConstant: 72),
            imageView.heightAnchor.constraint(equalToConstant: 72),

            checkmarkView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor, constant: 56),

            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .mediumLargeSpacing),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -.largeSpacing),

            bodyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumSpacing),
            bodyLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -.largeSpacing),
        ])
    }
}
