//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

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
        stackView.spacing = Warp.Spacing.spacing50
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
        layer.cornerRadius = Warp.Spacing.spacing100

        addSubview(stackView)
        stackView.fillInSuperview(insets: .init(top: 6, leading: Warp.Spacing.spacing100, bottom: -6, trailing: -Warp.Spacing.spacing100))

        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 14),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
        ])
    }
}
