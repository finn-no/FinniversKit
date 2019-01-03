//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

public final class EasterEggButton: UIButton {
    public override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .ice : .milk
        }
    }

    public override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .ice : .milk
        }
    }

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupStyles()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2

        guard let imageView = imageView, let titleLabel = titleLabel else { return }

        let imageSize = imageView.frame.size
        titleEdgeInsets = UIEdgeInsets(top: 0, leading: -imageSize.width, bottom: 0, trailing: 0)

        let titleSize = titleLabel.bounds.size
        imageEdgeInsets = UIEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: -titleSize.width)
    }

    private func setupStyles() {
        backgroundColor = .milk
        tintColor = .primaryBlue

        contentMode = .center

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.6

        setTitleColor(.white, for: .normal)
        titleLabel?.font = .detail

        adjustsImageWhenHighlighted = false
        setImage(UIImage(named: .easterEgg), for: .normal)
    }
}
