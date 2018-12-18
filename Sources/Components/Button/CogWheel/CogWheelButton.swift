//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

public final class CogWheelButton: UIButton {
    private let corners: UIRectCorner

    public override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .cogWheelHighlightedColor : .cogWheelColor
        }
    }

    public override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .cogWheelHighlightedColor : .cogWheelColor
        }
    }

    public override var intrinsicContentSize: CGSize {
        return CGSize(width: .largeSpacing, height: .largeSpacing)
    }

    // MARK: - Init

    @objc public required init(corners: UIRectCorner, autoLayout: Bool) {
        self.corners = corners
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = !autoLayout
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    public override func layoutSubviews() {
        super.layoutSubviews()
        let radius = CGSize(width: .mediumLargeSpacing, height: .mediumLargeSpacing)
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: radius)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }

    private func setup() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = .mediumLargeSpacing
        layer.shadowOpacity = 0.6

        backgroundColor = UIColor.cogWheelColor
        setImage(UIImage(named: .cogWheel), for: .normal)
    }
}

// MARK: - Private extensions

private extension UIColor {
    static var cogWheelColor: UIColor? {
        return UIColor(white: 1, alpha: 0.7)
    }

    static var cogWheelHighlightedColor: UIColor? {
        return UIColor.defaultButtonHighlightedBodyColor.withAlphaComponent(0.8)
    }
}
