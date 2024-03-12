//
//  Copyright © 2019 FINN AS. All rights reserved.
//

extension ChristmasWishListView {
    /// A custom call-to-action like button for the christmas wish list
    class ChristmasButton: UIButton {
        init() {
            super.init(frame: .zero)
            setup()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override var isHighlighted: Bool {
            didSet {
                backgroundColor = isHighlighted ? .christmasCallToActionHighlighted : .christmasCallToAction
            }
        }

        private func setup() {
            translatesAutoresizingMaskIntoConstraints = false
            setTitleColor(.textInverted, for: .normal)
            backgroundColor = .christmasCallToAction

            layer.cornerRadius = .spacingS
            imageEdgeInsets = UIEdgeInsets(trailing: .spacingS)
            titleLabel?.font = UIFont.bodyStrong
            contentEdgeInsets = UIEdgeInsets(all: .spacingS * 1.5)
            adjustsImageWhenHighlighted = false
        }
    }
}

private extension UIColor {
    class var christmasCallToAction: UIColor? {
        return .backgroundPrimary
    }

    class var christmasCallToActionHighlighted: UIColor? {
        return christmasCallToAction?.withAlphaComponent(0.8)
    }
}
