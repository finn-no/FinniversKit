//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class LoginView: UIView, Injectable {
    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    lazy var titleLabel: Label = {
        let view = Label(style: .title4(.licorice))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 0

        return view
    }()

    public func setup() {
        backgroundColor = .white

        titleLabel.text = "Logg inn for å sende meldinger, lagre favoritter og søk. Du får også varsler når det skjer noe nytt!"
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }
}
