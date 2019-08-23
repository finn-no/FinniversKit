//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

extension UIImageView {
    static var checkmarkImageView: UIImageView {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .primaryBlue
        imageView.image = UIImage(named: .check)
        imageView.tintColor = .milk
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}
