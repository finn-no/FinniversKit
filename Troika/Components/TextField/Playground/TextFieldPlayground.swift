//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Troika

public class TextFieldPlayground: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {

        let model = TextFieldDataModel.email

        let textField = TextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.model = model

        addSubview(textField)

        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }
}
