//
//  Copyright © 2021 FINN AS. All rights reserved.
//

import UIKit

public class RecentlySavedCell: UICollectionViewCell, ReuseIdentifiable {
    lazy private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.widthAnchor.constraint(equalToConstant: 64).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 32
        imageView.backgroundColor = .red
        return imageView
    }()
    
    lazy private var smallShadowView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.widthAnchor.constraint(equalToConstant: 64).isActive = true
        view.heightAnchor.constraint(equalToConstant: 64).isActive = true
        view.layer.cornerRadius = 32
        view.dropShadow(color: .init(hex: "#4755693D"),
                        opacity: 0.24, offset: .init(width: 0, height: 1), radius: 1)
        return view
    }()
    
    lazy private var largeShadowView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.widthAnchor.constraint(equalToConstant: 64).isActive = true
        view.heightAnchor.constraint(equalToConstant: 64).isActive = true
        view.layer.cornerRadius = 32
        view.dropShadow(color: .init(hex: "#4755693D"),
                        opacity: 0.16,
                        offset: .init(width: 0, height: 1),
                        radius: 4)
        return view
    }()
    
    lazy private var titleLabel: UILabel = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Elektronikk"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    lazy private var imageContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(largeShadowView)
        view.addSubview(smallShadowView)
        view.addSubview(imageView)
        
        imageView.fillInSuperview()
        largeShadowView.fillInSuperview()
        smallShadowView.fillInSuperview()
        
        return view
    }()
    
    lazy private var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        stackView.addArrangedSubviews([imageContainerView, titleLabel])
        stackView.spacing = 12
        return stackView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            imageContainerView.widthAnchor.constraint(equalToConstant: 64),
            imageContainerView.heightAnchor.constraint(equalToConstant: 64),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        
        imageContainerView.setContentCompressionResistancePriority(.required, for: .vertical)
    }
}
