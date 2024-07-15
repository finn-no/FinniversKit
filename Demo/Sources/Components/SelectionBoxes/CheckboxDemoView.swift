//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit
import Warp

class CheckboxDemoView: UIView, Demoable {
    var dismissKind: DismissKind { .button }

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

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .background
        addSubview(checkbox)

        NSLayoutConstraint.activate([
            checkbox.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing200),
            checkbox.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing200),
            checkbox.topAnchor.constraint(equalTo: topAnchor, constant: Warp.Spacing.spacing200)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - CheckboxDelegate

extension CheckboxDemoView: CheckboxDelegate {
    func checkbox(_ checkbox: Checkbox, didSelectItem item: CheckboxItem) {
        print("Selected item index:", item.index)
    }

    func checkbox(_ checkbox: Checkbox, didUnselectItem item: CheckboxItem) {
        print("Did unselected item", item)
    }
}
