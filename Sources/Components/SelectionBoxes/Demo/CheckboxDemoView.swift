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

        Selectionbox.appearance().font = .body
        Selectionbox.appearance().textColor = .licorice

        let checkboxSelected = UIImage.animatedImageNamed("checkbox-selected-", duration: 20 / 60.0)
        let checkboxUnselected = UIImage.animatedImageNamed("checkbox-unselected-", duration: 14 / 60.0)

        checkbox.selectedImage = checkboxSelected?.images?.last
        checkbox.selectedAnimationImages = checkboxSelected?.images
        checkbox.unselectedImage = checkboxUnselected?.images?.last
        checkbox.unselectedAnimationImages = checkboxUnselected?.images

        backgroundColor = .white
        addSubview(checkbox)

        NSLayoutConstraint.activate([
            checkbox.leftAnchor.constraint(equalTo: leftAnchor),
            checkbox.rightAnchor.constraint(equalTo: rightAnchor),
            checkbox.topAnchor.constraint(equalTo: topAnchor),
            checkbox.heightAnchor.constraint(equalToConstant: CGFloat(strings.count + 1) * 44),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CheckboxDemoView: SelectionboxDelegate {
    func selectionbox(_ selectionbox: Selectionbox, didSelectItem item: SelectionboxItem) {
        print("Selected item index:", item.index)
    }

    func selectionbox(_ selectionbox: Selectionbox, didUnselectItem item: SelectionboxItem) {
        print("Did unselected item", item)
    }
}
