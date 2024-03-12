//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

final class EarthHourTagView: UIView {
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = UIFont.font(ofSize: 14.0, weight: .regular, textStyle: .footnote)
        label.textColor = .text
        return label
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = UIImage(named: .earthHourClock).withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .icon
        return imageView
    }()

    private(set) lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .horizontal
        stackView.spacing = .spacingXS
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
        backgroundColor = .backgroundInfoSubtle
        layer.cornerRadius = .spacingS

        addSubview(stackView)
        stackView.fillInSuperview(insets: .init(top: 6, leading: .spacingS, bottom: -6, trailing: -.spacingS))

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 14),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
        ])
    }
}
