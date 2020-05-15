//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import UIKit

public final class PersonalNotificationIconView: UIView {

    public enum Kind {
        case favorite
        case myAds
    }

    private lazy var imageView = UIImageView(
        withAutoLayout: true
    )

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 12
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 1.2
        layer.borderColor = .milk
        layer.borderWidth = 2

        imageView.tintColor = .milk
        addSubview(imageView)

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 12),
            imageView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with icon: Kind?) {
        switch icon {
        case .favorite:
            backgroundColor = .secondaryBlue
            imageView.image = UIImage(named: .heartMini)
        case .myAds:
            backgroundColor = .primaryBlue
            imageView.image = UIImage(named: .tagMini)
        case .none:
            imageView.image = nil
        }
    }
}

private extension UIColor {
    static var deepPurple: UIColor { UIColor(hex: "B077DF") }
    static var ligthningYellow: UIColor { UIColor(hex: "FCC43F") }
}
