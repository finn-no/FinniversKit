//
//  Copyright © 2019 FINN AS. All rights reserved.
//

public class CheckmarkTitleView: UIView {
    private lazy var checkmarkImageView: UIImageView = {
        let image = UIImage(named: .checkmarkBig)
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        return label
    }()

    public init(title: String, withAutoLayout: Bool = false) {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        titleLabel.text = title

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CheckmarkTitleView {
    func setup() {
        addSubview(checkmarkImageView)
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            checkmarkImageView.heightAnchor.constraint(equalToConstant: 32),
            checkmarkImageView.widthAnchor.constraint(equalToConstant: 32),
            checkmarkImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .smallSpacing),

            titleLabel.centerYAnchor.constraint(equalTo: checkmarkImageView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: checkmarkImageView.trailingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}
