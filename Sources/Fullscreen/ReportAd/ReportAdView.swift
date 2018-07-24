//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public class ReportAdView: UIView {

    // MARK: - Private properties

    private let radioButtonFields = [
        "Mistanke om svindel",
        "Regebrudd",
        "Forhandler opptrer som privat",
    ]

    private lazy var radioButton: RadioButton = {
        let radioButton = RadioButton(strings: radioButtonFields)
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
        button.addTarget(self, action: #selector(helpButtonPressed(sender:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var contentView: UIView = {
        let content = UIView(frame: .zero)
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()
    
    // Used to scroll content view if needed when keyboard will appear
    private var contentTopConstraint: NSLayoutConstraint!

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

        registerKeyboardEvents()
        setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        contentView.addSubview(radioButton)
        contentView.addSubview(seperationLine)
        contentView.addSubview(descriptionView)
        contentView.addSubview(helpButton)
        addSubview(contentView)
        
        contentTopConstraint = contentView.topAnchor.constraint(equalTo: topAnchor)
        
        NSLayoutConstraint.activate([
            radioButton.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            radioButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            radioButton.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            seperationLine.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: .mediumLargeSpacing),
            seperationLine.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -.mediumLargeSpacing),
            seperationLine.topAnchor.constraint(equalTo: radioButton.bottomAnchor),
            seperationLine.heightAnchor.constraint(equalToConstant: 1),
            
            descriptionView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            descriptionView.topAnchor.constraint(equalTo: seperationLine.bottomAnchor),
            descriptionView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            
            helpButton.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: .mediumLargeSpacing),
            helpButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            contentView.leftAnchor.constraint(equalTo: leftAnchor),
            contentView.rightAnchor.constraint(equalTo: rightAnchor),
            contentTopConstraint,
            contentView.bottomAnchor.constraint(equalTo: helpButton.bottomAnchor, constant: .mediumLargeSpacing),
            ])
    }
    
    private func registerKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - Actions

    @objc func helpButtonPressed(sender: UIButton) {
        descriptionView.resignFirstResponder()
    }
    
    // MARK: - Keyboard Events

    @objc func keyboardWillShow(notification: Notification) {
        print("Keyboard will show!")
        guard let keyboardSize = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return }

        let overlap = keyboardSize.intersection(contentView.frame)
        
        if overlap != .null {
            guard let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
            guard let curve = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? UInt else { return }

            UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions(rawValue: curve), animations: {
                self.contentTopConstraint.constant = -overlap.height
                self.layoutIfNeeded()
            })
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        if contentTopConstraint.constant != 0 {
            guard let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else { return }
            guard let curve = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? UInt else { return }

            UIView.animate(withDuration: duration, delay: 0.0, options: UIViewAnimationOptions(rawValue: curve), animations: {
                self.contentTopConstraint.constant = 0
                self.layoutIfNeeded()
            })
        }
    }
}
