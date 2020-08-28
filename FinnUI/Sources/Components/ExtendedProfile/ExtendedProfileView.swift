//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class ExtendedProfileView: UIView {

    private lazy var headerImageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var sloganLabel: Label = {
        let label = Label(style: .bodyStrong, withAutoLayout: true)
        label.textAlignment = .center
        return label
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(headerImageView)
        addSubview(sloganLabel)

        NSLayoutConstraint.activate([
            headerImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            headerImageView.topAnchor.constraint(equalTo: topAnchor),
            headerImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            headerImageView.heightAnchor.constraint(equalToConstant: 150),

            sloganLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            sloganLabel.topAnchor.constraint(equalTo: headerImageView.bottomAnchor),
            sloganLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            sloganLabel.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    // MARK: - Public methods

    public func configue(with viewModel: ExtendedProfileViewModel) {
        headerImageView.image = viewModel.headerImage
        headerImageView.backgroundColor = viewModel.headerBackgroundColor

        sloganLabel.text = viewModel.sloganText
        sloganLabel.backgroundColor = viewModel.sloganBackgroundColor
        sloganLabel.textColor = viewModel.sloganTextColor
    }
}
