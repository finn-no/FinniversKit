//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import Bootstrap

final class EarthHourTagView: UIView {
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = UIFont.captionRegular
        label.textColor = .black
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .earthHourClock)
        return imageView
    }()

    private(set) lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .horizontal
        stackView.spacing = .smallSpacing
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill

        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(titleLabel)

        return stackView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        backgroundColor = UIColor(r: 196, g: 210, b: 231)
        layer.cornerRadius = .mediumSpacing

        addSubview(stackView)
        stackView.fillInSuperview(insets: .init(top: 6, leading: .mediumSpacing, bottom: -6, trailing: -.mediumSpacing))

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 14),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
        ])
    }
}
