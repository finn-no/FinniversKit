//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class CheckboxDemoView: UIView {
    let strings = [
        "Mistanke om svindel",
        "Regelbrudd",
        "Forhandler opptrer som privat"
    ]

    lazy var checkbox: Checkbox = {
        let box = Checkbox(strings: self.strings)
        box.title = "Check Box Title"
        box.delegate = self
        box.translatesAutoresizingMaskIntoConstraints = false
        return box
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .white
        addSubview(checkbox)

        NSLayoutConstraint.activate([
            checkbox.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkbox.trailingAnchor.constraint(equalTo: trailingAnchor),
            checkbox.topAnchor.constraint(equalTo: topAnchor)
        ])
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CheckboxDemoView: CheckboxDelegate {
    public func checkbox(_ checkbox: Checkbox, didSelectItem item: CheckboxItem) {
        print("Selected item index:", item.index)
    }

    public func checkbox(_ checkbox: Checkbox, didUnselectItem item: CheckboxItem) {
        print("Did unselected item", item)
    }
}
