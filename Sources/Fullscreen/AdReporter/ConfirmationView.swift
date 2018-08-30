//
//  Copyright © 2018 FINN.no. All rights reserved.
//

import UIKit

public protocol ConfirmationViewDelegate: class {
    func confirmationViewDidPressDismissButton(_ confirmationView: ConfirmationView)
}

public class ConfirmationView: UIView {
    
    // MARK: - Private properties
    
    private lazy var titleLabel: Label = {
        let label = Label(style: .title2)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var messageLabel: Label = {
        let label = Label(style: .body)
        label.textColor = .licorice
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var closeButton: Button = {
        let button = Button(style: .flat)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK - Public properties
    
    public var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue}
    }
    
    public var message: String? {
        get { return messageLabel.text }
        set { messageLabel.text = newValue }
    }
    
    public var buttonTitle: String? {
        get { return closeButton.titleLabel?.text }
        set { closeButton.setTitle(newValue, for: .normal) }
    }
    
    public weak var delegate: ConfirmationViewDelegate?
    
    // MARK: - Setup
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        view.addSubview(messageLabel)
        view.addSubview(closeButton)
        addSubview(view)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor),
            
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumLargeSpacing),
            messageLabel.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
            
            closeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            closeButton.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: .largeSpacing),
            
            view.topAnchor.constraint(equalTo: titleLabel.topAnchor),
            view.bottomAnchor.constraint(equalTo: closeButton.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .largeSpacing),
            view.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.largeSpacing),
            view.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        
        closeButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func buttonPressed() {
        delegate?.confirmationViewDidPressDismissButton(self)
    }
}
