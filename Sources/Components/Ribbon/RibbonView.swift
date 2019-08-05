//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class RibbonView: UIView {

    // MARK: - Public properties

    public var title: String = "" {
        didSet {
            update(title)
        }
    }

    public var style: Style = .default {
        didSet {
            backgroundColor = style.color
        }
    }

    // MARK: - Internal properties

    private lazy var titleLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    private let horisontalMargin: CGFloat = 8
    private let verticalMargin: CGFloat = 2
    private let cornerRadius: CGFloat = 8

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public init(style: Style) {
        self.style = style
        super.init(frame: .zero)
        setup()
    }

    public init(style: Style, with title: String) {
        self.style = style
        self.title = title
        super.init(frame: .zero)
        update(title)
        setup()
    }

    public required convenience init?(coder aDecoder: NSCoder) {
        self.init(style: .default)
    }

    // MARK: - Private methods

    private func setup() {
        layer.cornerRadius = cornerRadius
        isAccessibilityElement = true
        backgroundColor = style.color

        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horisontalMargin),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horisontalMargin),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalMargin),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: verticalMargin)
        ])
    }

    private func update(_ title: String) {
        titleLabel.text = title
        accessibilityLabel = title
    }
}
