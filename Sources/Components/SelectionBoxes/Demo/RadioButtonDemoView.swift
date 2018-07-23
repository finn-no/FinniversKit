//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class RadioButtonDemoView: UIView {
    let strings = [
        "Mistanke om svindel",
        "Regelbrudd",
        "Forhandler opptrer som privat",
    ]

    lazy var radioButton: RadioButton = {
        let box = RadioButton(strings: self.strings)
        box.title = "Radio Box Title"
        box.translatesAutoresizingMaskIntoConstraints = false
        return box
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let framesPerSecond = 60.0

        let radiobuttonSelected = UIImage.animatedImageNamed("radiobutton-select-", duration: 13 / framesPerSecond)
        let radiobuttonUnselected = UIImage.animatedImageNamed("radiobutton-unselected-", duration: 10 / framesPerSecond)

        radioButton.selectedImage = radiobuttonSelected?.images?.last
        radioButton.selectedAnimationImages = radiobuttonSelected?.images
        radioButton.unselectedImage = radiobuttonUnselected?.images?.last
        radioButton.unselectedAnimationImages = radiobuttonUnselected?.images

        backgroundColor = .white
        addSubview(radioButton)

        NSLayoutConstraint.activate([
            radioButton.leftAnchor.constraint(equalTo: leftAnchor),
            radioButton.rightAnchor.constraint(equalTo: rightAnchor),
            radioButton.topAnchor.constraint(equalTo: topAnchor),
            radioButton.heightAnchor.constraint(equalToConstant: CGFloat(strings.count + 1) * 44),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
