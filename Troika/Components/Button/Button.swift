//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class Button: UIButton {

    // MARK: - Internal properties

    private let cornerRadius: CGFloat = 4.0

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        isAccessibilityElement = true

        titleLabel?.font = .title4
        layer.cornerRadius = cornerRadius
    }

    // MARK: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()
    }

    // MARK: - Dependency injection

    public var presentable: ButtonPresentable? {
        didSet {
            guard let presentable = presentable else {
                return
            }

            accessibilityLabel = presentable.title
            setTitle(presentable.title, for: .normal)
            setTitleColor(presentable.type.textColor, for: .normal)
            layer.borderWidth = presentable.type.borderWidth
            layer.borderColor = presentable.type.borderColor.cgColor
            backgroundColor = presentable.type.bodyColor
        }
    }
}
