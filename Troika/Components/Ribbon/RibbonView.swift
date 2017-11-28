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
        layer.cornerRadius = cornerRadius
        isAccessibilityElement = true

        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horisontalMargin),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horisontalMargin),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -verticalMargin),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: verticalMargin),
        ])
    }

    // MARK: - Dependency injection

    public var model: RibbonModel? {
        didSet {
            titleLabel.text = model?.title
            accessibilityLabel = model?.accessibilityLabel
            backgroundColor = model?.type.color
        }
    }
}
