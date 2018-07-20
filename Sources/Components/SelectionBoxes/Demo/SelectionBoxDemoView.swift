//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class SelectionBoxDemoView: UIView {
    let strings = [
        "Mistanke om svindel",
        "Regelbrudd",
        "Forhandler opptrer som privat",
    ]

    lazy var checkbox: Checkbox = {
        let box = Checkbox(strings: self.strings)
        box.title = "Check Box Title"
        box.translatesAutoresizingMaskIntoConstraints = false
        return box
    }()

    lazy var radiobox: Radiobox = {
        let box = Radiobox(strings: self.strings)
        box.title = "Radio Box Title"
        box.translatesAutoresizingMaskIntoConstraints = false
        return box
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        SelectionBox.appearance().font = .body
        SelectionBox.appearance().textColor = .licorice

        let checkboxSelected = UIImage.animatedImageNamed("checkbox-selected-", duration: 20 / 60.0)
        let checkboxUnselected = UIImage.animatedImageNamed("checkbox-unselected-", duration: 14 / 60.0)

        checkbox.selectedImage = checkboxSelected?.images?.last
        checkbox.selectedAnimationImages = checkboxSelected?.images
        checkbox.unselectedImage = checkboxUnselected?.images?.last
        checkbox.unselectedAnimationImages = checkboxUnselected?.images

        let radiobuttonSelected = UIImage.animatedImageNamed("radiobutton-selected-", duration: 41 / 60.0)
        let radiobuttonUnselected = UIImage.animatedImageNamed("radiobutton-unselected-", duration: 10 / 60.0)

        radiobox.selectedImage = radiobuttonSelected?.images?.last
        radiobox.selectedAnimationImages = radiobuttonSelected?.images
        radiobox.unselectedImage = radiobuttonUnselected?.images?.last
        radiobox.unselectedAnimationImages = radiobuttonUnselected?.images

        backgroundColor = .white
        addSubview(checkbox)
        addSubview(radiobox)
        NSLayoutConstraint.activate([
            checkbox.leftAnchor.constraint(equalTo: leftAnchor),
            checkbox.rightAnchor.constraint(equalTo: rightAnchor),
            checkbox.topAnchor.constraint(equalTo: topAnchor),
            checkbox.heightAnchor.constraint(equalToConstant: CGFloat(strings.count + 1) * 44),

            radiobox.leftAnchor.constraint(equalTo: leftAnchor),
            radiobox.rightAnchor.constraint(equalTo: rightAnchor),
            radiobox.topAnchor.constraint(equalTo: checkbox.bottomAnchor, constant: 64),
            radiobox.heightAnchor.constraint(equalToConstant: CGFloat(strings.count + 1) * 44),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
