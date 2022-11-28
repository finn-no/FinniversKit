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
            titleLabel.textColor = style.textColor
        }
    }

    public private(set) lazy var titleLabel: Label = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.textAlignment = .center
        return label
    }()

    // MARK: - Init

    public convenience init(viewModel: RibbonViewModel) {
        self.init(style: viewModel.style, with: viewModel.title)
    }

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

    public func configure(with viewModel: RibbonViewModel) {
        style = viewModel.style
        title = viewModel.title
    }

    // MARK: - Private methods

    private func setup() {
        layer.cornerRadius = .spacingS
        isAccessibilityElement = true
        backgroundColor = style.color
        titleLabel.textColor = style.textColor

        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingS),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingS),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.spacingXXS),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .spacingXXS)
        ])
    }

    private func update(_ title: String) {
        titleLabel.text = title
        accessibilityLabel = title
    }
}
