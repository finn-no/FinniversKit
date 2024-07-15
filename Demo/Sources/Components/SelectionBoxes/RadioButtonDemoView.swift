//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit
import Warp

class RadioButtonDemoView: UIView, Demoable {
    var dismissKind: DismissKind { .button }

    let strings = [
        "Mistanke om svindel",
        "Regelbrudd",
        "Forhandler opptrer som privat"
    ]

    lazy var radioButton: RadioButton = {
        let box = RadioButton(strings: self.strings)
        box.title = "Radio Box Title"
        box.translatesAutoresizingMaskIntoConstraints = false
        return box
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .background
        addSubview(radioButton)

        NSLayoutConstraint.activate([
            radioButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing200),
            radioButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing200),
            radioButton.topAnchor.constraint(equalTo: topAnchor, constant: Warp.Spacing.spacing200)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
