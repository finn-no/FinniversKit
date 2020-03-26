//
//  Copyright © 2018 FINN AS. All rights reserved.
//

import UIKit

final class PianoEffectView: UIView {
    private(set) lazy var titleLabel: UILabel = {
        let label = UILabel(withAutoLayout: true)
        label.font = .caption
        label.textColor = UIColor(r: 143, g: 145, b: 150)
        label.textAlignment = .center
        return label
    }()

    private(set) lazy var control = PianoEffectControl(withAutoLayout: true)

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

        let controlWidth: CGFloat = UIDevice.current.userInterfaceIdiom == .pad ? 140 : 80

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),

            control.topAnchor.constraint(equalTo: topAnchor),
            control.bottomAnchor.constraint(equalTo: bottomAnchor),
            control.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 10),
            control.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            control.widthAnchor.constraint(equalToConstant: controlWidth),
            control.heightAnchor.constraint(equalTo: control.widthAnchor)
        ])
    }
}
