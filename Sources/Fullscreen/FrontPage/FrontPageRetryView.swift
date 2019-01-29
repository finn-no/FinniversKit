//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

protocol FrontPageRetryViewDelegate: AnyObject {
    func frontPageRetryViewDidSelectButton(_ view: FrontPageRetryView)
}

final class FrontPageRetryView: UIView {
    enum State {
        case hidden, labelAndButton, loading
    }

    weak var delegate: FrontPageRetryViewDelegate?

    var state: State = .hidden {
        didSet {
            configure(for: state)
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: bounds.width, height: button.frame.maxY)
    }

    // MARK: - Subviews

    private(set) lazy var label: UILabel = {
        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    private(set) lazy var button: UIButton = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleButtonTap), for: .touchUpInside)
        return button
    }()

    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView(style: .whiteLarge)
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        indicatorView.color = .primaryBlue
        return indicatorView
    }()

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configure(for: state)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    func set(labelText: String?, buttonText: String?) {
        label.text = labelText
        button.setTitle(buttonText, for: .normal)
    }

    private func setup() {
        backgroundColor = .milk

        addSubview(label)
        addSubview(button)
        addSubview(activityIndicatorView)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),

            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: .largeSpacing),
            button.centerXAnchor.constraint(equalTo: label.centerXAnchor),

            activityIndicatorView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            activityIndicatorView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
    }

    private func configure(for state: State) {
        switch state {
        case .hidden:
            activityIndicatorView.stopAnimating()
            isHidden = true
        case .labelAndButton:
            button.isHidden = false
            label.isHidden = false
            activityIndicatorView.stopAnimating()
            isHidden = false
        case .loading:
            button.isHidden = true
            label.isHidden = true
            activityIndicatorView.startAnimating()
            isHidden = false
        }
    }

    // MARK: - Actions

    @objc private func handleButtonTap() {
        delegate?.frontPageRetryViewDidSelectButton(self)
    }
}
