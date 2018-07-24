//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class ReportAdView: UIView {
    private let fields = [
        "Mistanke om svindel",
        "Regebrudd",
        "Forhandler opptrer som privat",
    ]

    private lazy var radioButton: RadioButton = {
        let radioButton = RadioButton(strings: fields)
        radioButton.title = "Hva gjelder det?"
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        return radioButton
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        let framesPerSecond = 60.0

        let radiobuttonSelected = UIImage.animatedImageNamed("radiobutton-select-", duration: 13 / framesPerSecond)
        let radiobuttonUnselected = UIImage.animatedImageNamed("radiobutton-unselected-", duration: 10 / framesPerSecond)

        radioButton.selectedImage = radiobuttonSelected?.images?.last
        radioButton.selectedAnimationImages = radiobuttonSelected?.images
        radioButton.unselectedImage = radiobuttonUnselected?.images?.last
        radioButton.unselectedAnimationImages = radiobuttonUnselected?.images

        setupSubviews()
    }

    private func setupSubviews() {
        addSubview(radioButton)
        NSLayoutConstraint.activate([
            radioButton.leftAnchor.constraint(equalTo: leftAnchor),
            radioButton.topAnchor.constraint(equalTo: topAnchor),
            radioButton.rightAnchor.constraint(equalTo: rightAnchor),
            radioButton.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1 / 4),
        ])
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
