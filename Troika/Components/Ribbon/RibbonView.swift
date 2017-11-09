//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public enum RibbonType {
    case ordinary
    case success
    case warning
    case error
    case disabled
    case sponsored

    var color: UIColor {
        switch self {
        case .ordinary: return .ice
        case .success: return .mint
        case .warning: return .banana
        case .error: return .salmon
        case .disabled: return .sardine
        case .sponsored: return .toothPaste
        }
    }
}

public class RibbonView: UIView {

    // Mark: - Internal properties

    private lazy var titleLabel: Label = {
        let label = Label()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.style = .detail(.licorice)
        return label
    }()

    let horisontalMargin: CGFloat = 8
    let verticalMargin: CGFloat = 2
    let cornerRadius: CGFloat = 3

    // Mark: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        layer.cornerRadius = cornerRadius
        isAccessibilityElement = true

        addSubview(titleLabel)
    }

    // Mark: - Layout

    public override func layoutSubviews() {
        super.layoutSubviews()

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horisontalMargin),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horisontalMargin),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalMargin),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: verticalMargin),
        ])
    }

    // Mark: - Dependency injection

    public var presentable: RibbonPresentable? {
        didSet {
            titleLabel.text = presentable?.title
            accessibilityLabel = presentable?.accessibilityLabel
            backgroundColor = presentable?.type.color
        }
    }
}
