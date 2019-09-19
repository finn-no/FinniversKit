//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class RadioButtonDemoView: UIView {
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

    public override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .bgPrimary
        addSubview(radioButton)

        NSLayoutConstraint.activate([
            radioButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            radioButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            radioButton.topAnchor.constraint(equalTo: topAnchor)
            ])
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
