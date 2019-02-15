//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import FinniversKit

class FullscreenGalleryDemoView: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        let label = Label(style: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = "Tap an image to open the fullscreen gallery"
        label.textAlignment = .center

        addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.largeSpacing)
        ])
    }
}
