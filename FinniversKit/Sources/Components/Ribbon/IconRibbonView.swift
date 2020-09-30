//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class IconRibbonView: UIView {

    // MARK: - Private properties

    private lazy var iconImageView = UIImageView(withAutoLayout: true)
    private var style: RibbonView.Style = .default
    private let horisontalMargin: CGFloat = .spacingM
    private let verticalMargin: CGFloat = 3
    private let cornerRadius: CGFloat = 8

    // MARK: - Init

    public convenience init(viewModel: IconRibbonViewModel) {
        self.init(style: viewModel.style, with: viewModel.icon)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public init(style: RibbonView.Style) {
        self.style = style
        super.init(frame: .zero)
        setup()
    }

    public init(style: RibbonView.Style, with icon: UIImage) {
        self.style = style
        super.init(frame: .zero)
        self.iconImageView.image = icon
        setup()
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(style: .default)
    }

    public func configure(with viewModel: IconRibbonViewModel) {
        style = viewModel.style
        iconImageView.image = viewModel.icon
    }

    // MARK: - Private methods

    private func setup() {
        layer.cornerRadius = cornerRadius
        isAccessibilityElement = true
        backgroundColor = style.color

        addSubview(iconImageView)

        NSLayoutConstraint.activate([
            iconImageView.heightAnchor.constraint(equalToConstant: 12),
            iconImageView.widthAnchor.constraint(equalToConstant: 12),

            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horisontalMargin),
            iconImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horisontalMargin),
            iconImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalMargin),
            iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: verticalMargin)
        ])
    }
}
