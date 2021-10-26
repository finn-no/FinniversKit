//
//  ChristmasPromotionCell.swift
//

import UIKit

public protocol PromotionCellDelegate {
    func didSelectItem(_ promotionCell: ChristmasPromotionCell)
}


public class ChristmasPromotionCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: self)
    
    private lazy var background: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .bgPrimary
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var smallShadowView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.dropShadow(color:UIColor(hex: "475569"), opacity: 0.24, offset: CGSize(width: 0, height: 1), radius: 1)
        return view
    }()
    
    private lazy var largeShadowView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.dropShadow(color: UIColor(hex: "475569"), opacity: 0.16, offset: CGSize(width: 0, height: 1), radius: 5)
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = Label(style: .title3Strong, withAutoLayout: true)
        label.text = "Hjelp til jul hos Finn"
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.text = "Julen skal være en fin tid for all…"
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var button: Button = {
        let button = Button(style: .default,size: .small, withAutoLayout: true)
        button.setTitle("Be om eller tilby hjelp til jul", for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var image: UIImageView = {
        let image = UIImage(named: .christmasPromotion)
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = image
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var verticalStack: UIStackView = {
        let stack = UIStackView(withAutoLayout: true)
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fillProportionally
        stack.addArrangedSubviews([titleLabel, subtitleLabel, button])
        stack.setCustomSpacing(16, after: subtitleLabel)
        return stack
    }()
    
    public var delegate: PromotionCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutIfNeeded() {
        super.layoutIfNeeded()
    }
}

// MARK: Setup
extension ChristmasPromotionCell {
    private func setup() {
        contentView.addSubview(largeShadowView)
        largeShadowView.fillInSuperview()
        largeShadowView.addSubview(smallShadowView)
        smallShadowView.fillInSuperview()
        smallShadowView.addSubview(background)
        background.fillInSuperview()
        background.addSubview(verticalStack)
        background.addSubview(image)
        
        NSLayoutConstraint.activate([
            verticalStack.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            verticalStack.topAnchor.constraint(equalTo: background.topAnchor, constant: 20),
            verticalStack.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -20),
            verticalStack.trailingAnchor.constraint(lessThanOrEqualTo: image.leadingAnchor, constant: 20),
            image.trailingAnchor.constraint(equalTo: background.trailingAnchor),
            image.topAnchor.constraint(equalTo: background.topAnchor),
            image.bottomAnchor.constraint(equalTo: background.bottomAnchor),
        ])
        layoutIfNeeded()
    }
    
    @objc private func buttonTapped() {
        delegate?.didSelectItem(self)
    }
}
