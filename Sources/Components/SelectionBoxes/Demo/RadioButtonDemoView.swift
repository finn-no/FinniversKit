//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

class RadioButtonDemoView: UIView {
    let strings = [
        "Mistanke om svindel",
        "Regelbrudd",
        "Forhandler opptrer som privat",
    ]

    lazy var radioButton: RadioButton = {
        let box = RadioButton(strings: self.strings)
        box.title = "Radio Box Title"
        box.translatesAutoresizingMaskIntoConstraints = false
        return box
    }()

    lazy var dismissButton: Button = {
        let button = Button(style: .callToAction)
        button.setTitle("Enable Double Tap", for: .normal)
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private var touchEnabled = false

    override init(frame: CGRect) {
        super.init(frame: frame)

        let radiobuttonSelected = UIImage.animatedImageNamed("radiobutton-selected-", duration: 41 / 60.0)
        let radiobuttonUnselected = UIImage.animatedImageNamed("radiobutton-unselected-", duration: 10 / 60.0)

        radioButton.selectedImage = radiobuttonSelected?.images?.last
        radioButton.selectedAnimationImages = radiobuttonSelected?.images
        radioButton.unselectedImage = radiobuttonUnselected?.images?.last
        radioButton.unselectedAnimationImages = radiobuttonUnselected?.images

        backgroundColor = .white
        addSubview(radioButton)
        addSubview(dismissButton)

        NSLayoutConstraint.activate([
            radioButton.leftAnchor.constraint(equalTo: leftAnchor),
            radioButton.rightAnchor.constraint(equalTo: rightAnchor),
            radioButton.topAnchor.constraint(equalTo: topAnchor),
            radioButton.heightAnchor.constraint(equalToConstant: CGFloat(strings.count + 1) * 44),

            dismissButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
            dismissButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }

    @objc func dismiss() {
        guard let doubleTap = superview?.gestureRecognizers?.first else { return }

        if touchEnabled {
            dismissButton.setTitle("Enable Double Tap", for: .normal)
            touchEnabled = false
            doubleTap.isEnabled = false
        } else {
            dismissButton.setTitle("Disable Double Tap", for: .normal)
            touchEnabled = true
            doubleTap.isEnabled = true
        }
    }

    override func didMoveToSuperview() {
        guard let doubleTap = superview?.gestureRecognizers?.first else { return }
        touchEnabled = false
        doubleTap.isEnabled = false
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
