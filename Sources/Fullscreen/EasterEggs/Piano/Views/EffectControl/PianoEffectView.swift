//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit

final class PianoEffectView: UIView {
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor(r: 143, g: 145, b: 150)
        label.textAlignment = .center
        return label
    }()

    private(set) lazy var control: PianoEffectControl = {
        let view = PianoEffectControl()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setup() {
        addSubview(titleLabel)
        addSubview(control)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),

            control.topAnchor.constraint(equalTo: topAnchor),
            control.bottomAnchor.constraint(equalTo: bottomAnchor),
            control.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            control.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            control.widthAnchor.constraint(equalToConstant: 80),
            control.heightAnchor.constraint(equalTo: control.widthAnchor)
        ])
    }
}
