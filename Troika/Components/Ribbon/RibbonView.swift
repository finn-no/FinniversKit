//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class RibbonView: UIView {

    // MARK: - Internal properties

    private lazy var titleLabel: Label = {
        let label = Label(style: .detail(.licorice))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    let horisontalMargin: CGFloat = 8
    let verticalMargin: CGFloat = 2
    let cornerRadius: CGFloat = 3

    // MARK: - External properties

    public var title: String = "" {
        didSet {
            titleLabel.text = title
            accessibilityLabel = title
        }
    }

    public let style: Style

    // MARK: - Setup

    public init(style: Style) {
        self.style = style
        super.init(frame: .zero)
        setup()
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(style: .default)
    }

    private func setup() {
        layer.cornerRadius = cornerRadius
        isAccessibilityElement = true

        backgroundColor = style.color

        addSubview(titleLabel)
    }

    // MARK: - Layout
    public override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horisontalMargin),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horisontalMargin),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalMargin),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: verticalMargin),
        ])
    }
}
