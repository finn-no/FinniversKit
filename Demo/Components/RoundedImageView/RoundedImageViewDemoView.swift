//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import Foundation

public class RoundedImageViewDemoView: UIView {
    private lazy var roundedImageView: RoundedImageView = {
        let imageView = RoundedImageView()
        imageView.image = UIImage(named: "AppIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(roundedImageView)

        NSLayoutConstraint.activate([
            roundedImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            roundedImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
