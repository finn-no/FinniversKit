//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit
import DemoKit

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

        backgroundColor = .bgPrimary
        addSubview(radioButton)

        NSLayoutConstraint.activate([
            radioButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            radioButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            radioButton.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM)
            ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
