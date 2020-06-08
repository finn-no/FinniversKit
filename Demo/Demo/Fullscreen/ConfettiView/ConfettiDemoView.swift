//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinnUI
import FinniversKit

class ConfettiDemoView: UIView {

    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView))

    private lazy var label: Label = {
        let label = Label(style: .bodyRegular, withAutoLayout: true)
        label.text = "Tap to start confetti animation"
        return label
    }()

    private lazy var confettiView: ConfettiView = {
        let view = ConfettiView(withAutoLayout: true)
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        addSubview(label)
        addSubview(confettiView)
        addGestureRecognizer(tapGestureRecognizer)

        confettiView.fillInSuperview()

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    @objc private func didTapView() {
        label.text = "Look at all the confetti 🎉"

        confettiView.start(withDuration: 0.75, completion: { [weak self] in
            self?.label.text = "Done with animation, tap to show again"
        })
    }
}
