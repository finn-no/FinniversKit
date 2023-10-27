class StoryBorderView: UIView {
    private var borderSize: CGSize = .zero
    private var isRead: Bool = true

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        if frame.size != borderSize {
            updateGradientBorder()
        }
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateGradientBorder()
        }
    }

    // MARK: - Internal functions

    func configure(isRead: Bool) {
        guard self.isRead != isRead else { return }
        self.isRead = isRead
        updateGradientBorder()
    }

    // MARK: - Private functions

    private func updateGradientBorder() {
        borderSize = frame.size

        layer.sublayers?.forEach({ $0.removeFromSuperlayer() })

        let shape = CAShapeLayer()
        shape.lineWidth = isRead ? 2 : 4
        shape.path = UIBezierPath(roundedRect: bounds, cornerRadius: layer.cornerRadius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor

        let topColor = isRead ? .backgroundDisabled : UIColor.unreadStoryTopGradientColor
        let bottomColor = isRead ? .backgroundDisabled : UIColor.unreadStoryBottomGradientColor

        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: .zero, size: frame.size)
        gradient.colors = [topColor, bottomColor]
        gradient.mask = shape

        layer.addSublayer(gradient)
    }
}

private extension UIColor {
    static var unreadStoryTopGradientColor: CGColor {
        UIColor.nmpBrandColorPrimary.cgColor
    }

    static var unreadStoryBottomGradientColor: CGColor {
        UIColor.nmpBrandColorSecondary.cgColor
    }
}
