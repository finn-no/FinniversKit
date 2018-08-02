//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class CheckboxDemoView: UIView {
    let strings = [
        "Mistanke om svindel",
        "Regelbrudd",
        "Forhandler opptrer som privat",
    ]

    lazy var checkbox: Checkbox = {
        let box = Checkbox(strings: self.strings)
        box.title = "Check Box Title"
        box.delegate = self
        box.translatesAutoresizingMaskIntoConstraints = false
        return box
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        let framesPerSecond = 60.0

        let checkboxSelected = UIImage.animatedImageNamed("checkbox-selected-", duration: 20 / framesPerSecond)
        let checkboxUnselected = UIImage.animatedImageNamed("checkbox-unselected-", duration: 14 / framesPerSecond)

        checkbox.selectedImage = checkboxSelected?.images?.last
        checkbox.selectedAnimationImages = checkboxSelected?.images
        checkbox.unselectedImage = checkboxUnselected?.images?.last
        checkbox.unselectedAnimationImages = checkboxUnselected?.images

        backgroundColor = .white
        addSubview(checkbox)

        NSLayoutConstraint.activate([
            checkbox.leadingAnchor.constraint(equalTo: leftAnchor),
            checkbox.trailingAnchor.constraint(equalTo: rightAnchor),
            checkbox.topAnchor.constraint(equalTo: topAnchor),
            checkbox.heightAnchor.constraint(equalToConstant: CGFloat(strings.count + 1) * 44),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CheckboxDemoView: CheckboxDelegate {
    func checkbox(_ checkbox: Checkbox, didSelectItem item: CheckboxItem) {
        print("Selected item index:", item.index)
    }

    func checkbox(_ checkbox: Checkbox, didUnselectItem item: CheckboxItem) {
        print("Did unselected item", item)
    }
}
