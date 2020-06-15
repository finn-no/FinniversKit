//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

class ConfettiDemoView: UIView {

    // MARK: - Private properties

    private var animationDuration: Float! {
        didSet {
            let buttonTitle = String(format: "Let it rain for %.2fs! 🎉", animationDuration)
            button.setTitle(buttonTitle, for: .normal)
        }
    }

    private lazy var confettiView = ConfettiView(withAutoLayout: true)

    private lazy var button: Button = {
        let button = Button(style: .default, withAutoLayout: true)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        return button
    }()

    private lazy var slider: UISlider = {
        let slider = UISlider(withAutoLayout: true)
        slider.addTarget(self, action: #selector(didUpdateAnimationDuration), for: .valueChanged)
        slider.setValue(animationDuration, animated: false)
        slider.minimumValue = 0.5
        slider.maximumValue = 10
        return slider
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        animationDuration = 0.75

        addSubview(slider)
        addSubview(button)
        addSubview(confettiView)

        confettiView.fillInSuperview()

        let buttonWidthConstraint = button.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.75)
        buttonWidthConstraint.priority = .init(999)

        NSLayoutConstraint.activate([
            slider.widthAnchor.constraint(equalTo: button.widthAnchor),
            slider.centerXAnchor.constraint(equalTo: centerXAnchor),

            button.topAnchor.constraint(equalTo: slider.bottomAnchor, constant: .spacingM),
            buttonWidthConstraint,
            button.widthAnchor.constraint(lessThanOrEqualToConstant: 300),
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: - Private methods

    @objc private func didTapButton() {
        confettiView.start(withDuration: TimeInterval(animationDuration), completion: {
            print("Confetti rain completed")
        })
    }

    @objc private func didUpdateAnimationDuration(_ sender: UISlider) {
        animationDuration = sender.value
    }
}
