//
//  Copyright © 2019 FINN AS. All rights reserved.
//

public class AdConfirmationObjectView: UIView {
    private lazy var imageView: RemoteImageView = {
        let imageView = RemoteImageView(withAutoLayout: true)
        imageView.dataSource = self
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8.0
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let titleLabel = Label(style: .title3Strong, withAutoLayout: true)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
    return titleLabel
    }()

    private lazy var bodyLabel: Label = {
        let bodyLabel = Label(style: .body, withAutoLayout: true)
        bodyLabel.numberOfLines = 0
        bodyLabel.textAlignment = .center
        return bodyLabel
    }()

    private let imageSize: CGFloat = 88.0
    private let fallbackImageSize: CGFloat = 40.0

    private var imageTopAnchorConstraint: NSLayoutConstraint?
    private var imageWidthConstraint: NSLayoutConstraint?
    private var imageHeightConstraint: NSLayoutConstraint?

    public var model: AdConfirmationObjectViewModel? {
        didSet {
            imageView.loadImage(for: model?.imageUrl?.absoluteString ?? "", imageWidth: imageSize)

            titleLabel.text = model?.title
            bodyLabel.text = model?.body
        }
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension AdConfirmationObjectView {
    func setup() {
        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(bodyLabel)

        imageTopAnchorConstraint = imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 56)
        imageWidthConstraint = imageView.widthAnchor.constraint(equalToConstant: imageSize)
        imageHeightConstraint = imageView.heightAnchor.constraint(equalToConstant: imageSize)

        guard
            let imageTopAnchor = imageTopAnchorConstraint,
            let imageWidth = imageWidthConstraint,
            let imageHeight = imageHeightConstraint
        else { return }

        NSLayoutConstraint.activate([
            imageTopAnchor,
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageWidth,
            imageHeight,

            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: .mediumLargeSpacing),
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -.largeSpacing),

            bodyLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            bodyLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -.largeSpacing),
        ])
    }

    func setupCheckmarkView() {
        let checkmarkView: RoundedImageView = RoundedImageView(withAutoLayout: true)
        checkmarkView.image = UIImage(named: .checkCircleFilledMini)
        addSubview(checkmarkView)

        NSLayoutConstraint.activate([
            checkmarkView.bottomAnchor.constraint(equalTo: imageView.topAnchor, constant: .mediumLargeSpacing),
            checkmarkView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -.mediumLargeSpacing),
            checkmarkView.widthAnchor.constraint(equalToConstant: 40),
            checkmarkView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func fallbackImageView() {
        imageView.image = UIImage(named: .checkCircleFilledMini)
        UIView.animate(withDuration: 0.1, animations: { [weak self] in
            guard let self = self else { return }
            self.imageTopAnchorConstraint?.constant += (self.imageSize - self.fallbackImageSize)
            self.imageHeightConstraint?.constant = self.fallbackImageSize
            self.imageWidthConstraint?.constant = self.fallbackImageSize
        })
    }
}

extension AdConfirmationObjectView: RemoteImageViewDataSource {
    public func remoteImageView(_ view: RemoteImageView, cachedImageWithPath imagePath: String, imageWidth: CGFloat) -> UIImage? { return nil }
    public func remoteImageView(_ view: RemoteImageView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}

    public func remoteImageView(_ view: RemoteImageView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: imagePath) else {
            completion(nil)
            self.fallbackImageView()
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                    self.setupCheckmarkView()
                } else {
                    completion(nil)
                    self.fallbackImageView()
                }
            }
        }

        task.resume()

    }
}
