//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public final class CalloutView: UIView {
    private lazy var boxView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .mint
        view.layer.borderColor = .pea
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 2
        return view
    }()

    private lazy var textLabel: UILabel = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    func show(withText text: String) {
        textLabel.text = text
    }

    func hide() {

    }

    private func setup() {
        addSubview(boxView)
        addSubview(textLabel)

        NSLayoutConstraint.activate([
            boxView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            boxView.leadingAnchor.constraint(equalTo: leadingAnchor),
            boxView.trailingAnchor.constraint(equalTo: trailingAnchor),
            boxView.bottomAnchor.constraint(equalTo: bottomAnchor),

            textLabel.topAnchor.constraint(equalTo: boxView.topAnchor, constant: .mediumSpacing),
            textLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: .mediumSpacing),
            textLabel.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -.mediumSpacing),
            textLabel.bottomAnchor.constraint(equalTo: boxView.bottomAnchor, constant: -.mediumSpacing)
        ])
    }
}
