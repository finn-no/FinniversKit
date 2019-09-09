//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public class Panel: UIView {
    private let cornerRadius: CGFloat = 8

    private lazy var textLabel: Label = {
        let label = Label(style: .body, withAutoLayout: true)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        label.textColor = style.textColor
        return label
    }()

    private let style: Panel.Style

    public init(style: Panel.Style) {
        self.style = style
        super.init(frame: CGRect(x: 0, y: 0, width: 320, height: 20))
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func configure(with viewModel: PanelViewModel) {
        layer.cornerRadius = viewModel.cornerRadius
        textLabel.text = viewModel.text
        setNeedsLayout()
    }

    private func setup() {
        isAccessibilityElement = true

        layer.cornerRadius = cornerRadius
        clipsToBounds = true

        textLabel.textColor = style.textColor
        backgroundColor = style.backgroundColor
        if let borderColor = style.borderColor {
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = 2.0 / UIScreen.main.scale
        } else {
            layer.borderColor = nil
            layer.borderWidth = 0
        }

        addSubview(textLabel)
        textLabel.fillInSuperview(margin: .mediumSpacing)
    }
}
