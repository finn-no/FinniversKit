//
//  ChristmasPromotionView.swift
//  FinniversKit
//

import UIKit

public protocol PromotionViewDelegate {
    func didSelectPromotion(_ promotion: ChristmasPromotionView)
}

public class ChristmasPromotionView: UIView {
    static let height: CGFloat = 150
    
    private lazy var backgroundView: UIView = {
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
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = Label(style: .caption, withAutoLayout: true)
        label.text = "Julen skal være en fin tid for all…"
        label.numberOfLines = 1
        label.setContentCompressionResistancePriority(.required, for: .vertical)
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
        imageView.setContentCompressionResistancePriority(.required, for: .horizontal)
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
    
    public var delegate: PromotionViewDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private functions
extension ChristmasPromotionView {
    private func setup() {
        addSubview(largeShadowView)
        largeShadowView.fillInSuperview()
        largeShadowView.addSubview(smallShadowView)
        smallShadowView.fillInSuperview()
        smallShadowView.addSubview(backgroundView)
        backgroundView.fillInSuperview()
        backgroundView.addSubview(verticalStack)
        backgroundView.addSubview(image)
        
        NSLayoutConstraint.activate([
            verticalStack.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: .spacingM),
            verticalStack.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: .spacingL),
            verticalStack.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -.spacingL),
            verticalStack.trailingAnchor.constraint(lessThanOrEqualTo: image.leadingAnchor, constant: .spacingS),
            image.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            image.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            image.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            image.widthAnchor.constraint(equalToConstant: 130)
        ])
    }
    
    @objc private func buttonTapped() {
        delegate?.didSelectPromotion(self)
    }
}
