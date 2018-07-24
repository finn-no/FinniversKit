//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class ReportAdView: UIView {

    // MARK: - Private properties

    private let fields = [
        "Mistanke om svindel",
        "Regebrudd",
        "Forhandler opptrer som privat",
    ]

    private lazy var radioButton: RadioButton = {
        let radioButton = RadioButton(strings: fields)
        radioButton.title = "Hva gjelder det?"
        radioButton.translatesAutoresizingMaskIntoConstraints = false
        return radioButton
    }()

    private lazy var seperationLine: UIView = {
        let line = UIView(frame: .zero)
        line.backgroundColor = .sardine
        line.translatesAutoresizingMaskIntoConstraints = false
        return line
    }()

    private lazy var descriptionView: DescriptionView = {
        let descriptionView = DescriptionView(frame: .zero)
        descriptionView.translatesAutoresizingMaskIntoConstraints = false
        return descriptionView
    }()

    private lazy var helpButton: Button = {
        let button = Button(style: .link)
        button.setTitle("Trenger du hjelp?", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Setup

    public override init(frame: CGRect) {
        super.init(frame: frame)

        let framesPerSecond = 60.0

        let radiobuttonSelected = UIImage.animatedImageNamed("radiobutton-select-", duration: 13 / framesPerSecond)
        let radiobuttonUnselected = UIImage.animatedImageNamed("radiobutton-unselected-", duration: 10 / framesPerSecond)

        radioButton.selectedImage = radiobuttonSelected?.images?.last
        radioButton.selectedAnimationImages = radiobuttonSelected?.images
        radioButton.unselectedImage = radiobuttonUnselected?.images?.last
        radioButton.unselectedAnimationImages = radiobuttonUnselected?.images

        setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupSubviews() {
        addSubview(radioButton)
        addSubview(seperationLine)
        addSubview(descriptionView)
        addSubview(helpButton)

        NSLayoutConstraint.activate([
            radioButton.leftAnchor.constraint(equalTo: leftAnchor),
            radioButton.topAnchor.constraint(equalTo: topAnchor),
            radioButton.rightAnchor.constraint(equalTo: rightAnchor),

            seperationLine.leftAnchor.constraint(equalTo: leftAnchor, constant: .mediumLargeSpacing),
            seperationLine.rightAnchor.constraint(equalTo: rightAnchor, constant: -.mediumLargeSpacing),
            seperationLine.topAnchor.constraint(equalTo: radioButton.bottomAnchor),
            seperationLine.heightAnchor.constraint(equalToConstant: 1),

            descriptionView.leftAnchor.constraint(equalTo: leftAnchor),
            descriptionView.topAnchor.constraint(equalTo: seperationLine.bottomAnchor),
            descriptionView.rightAnchor.constraint(equalTo: rightAnchor),

            helpButton.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: .mediumLargeSpacing),
            helpButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
}
