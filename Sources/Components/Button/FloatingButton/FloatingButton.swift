//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

public final class FloatingButton: UIButton {
    private let badgeSize: CGFloat = 30

    public override var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? .bgSecondary : .bgPrimary
        }
    }

    private lazy var badgeView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .btnPrimary
        view.layer.cornerRadius = badgeSize / 2
        view.isHidden = true
        return view
    }()

    private lazy var badgeLabel: UILabel = {
        let label = Label(style: .captionStrong)
        label.textColor = .textPrimary
        label.text = "12"
        label.textAlignment = .center
        return label
    }()

    public override var isSelected: Bool {
        didSet {
            backgroundColor = isSelected ? .bgSecondary : .bgPrimary
        }
    }

    public var itemsCount: Int = 0 {
        didSet {
            badgeLabel.text = "\(itemsCount)"
            badgeView.isHidden = itemsCount == 0
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
        backgroundColor = .bgPrimary
        tintColor = .btnPrimary

        contentMode = .center

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.6

        setTitleColor(.white, for: .normal)
        titleLabel?.font = .detail

        adjustsImageWhenHighlighted = false
        setImage(UIImage(named: .easterEgg), for: .normal)

        addSubview(badgeView)
        badgeView.addSubview(badgeLabel)
        badgeLabel.fillInSuperview()

        NSLayoutConstraint.activate([
            badgeView.widthAnchor.constraint(equalToConstant: badgeSize),
            badgeView.heightAnchor.constraint(equalToConstant: badgeSize),
            badgeView.topAnchor.constraint(equalTo: topAnchor, constant: -.smallSpacing),
            badgeView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: .smallSpacing),
            ])
    }
}
