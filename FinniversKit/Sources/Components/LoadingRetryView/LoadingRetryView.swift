//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

public protocol LoadingRetryViewDelegate: AnyObject {
    func loadingRetryViewDidSelectButton(_ view: LoadingRetryView)
}

public final class LoadingRetryView: UIView {
    public enum State {
        case hidden, labelAndButton, loading
    }

    public weak var delegate: LoadingRetryViewDelegate?

    public var state: State = .hidden {
        didSet {
            configure(for: state)
        }
    }

    public override var intrinsicContentSize: CGSize {
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

    private lazy var loadingIndicatorView: LoadingIndicatorView = {
        let view = LoadingIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        configure(for: state)
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    public func set(labelText: String?, buttonText: String?) {
        label.text = labelText
        button.setTitle(buttonText, for: .normal)
    }

    private func setup() {
        backgroundColor = .background

        addSubview(label)
        addSubview(button)
        addSubview(loadingIndicatorView)

        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: Warp.Spacing.spacing100),
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Warp.Spacing.spacing100),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing100),

            button.topAnchor.constraint(equalTo: label.bottomAnchor, constant: Warp.Spacing.spacing400),
            button.centerXAnchor.constraint(equalTo: label.centerXAnchor),

            loadingIndicatorView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            loadingIndicatorView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            loadingIndicatorView.widthAnchor.constraint(equalToConstant: 40),
            loadingIndicatorView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func configure(for state: State) {
        switch state {
        case .hidden:
            loadingIndicatorView.stopAnimating()
            isHidden = true
        case .labelAndButton:
            button.isHidden = false
            label.isHidden = false
            loadingIndicatorView.stopAnimating()
            isHidden = false
        case .loading:
            button.isHidden = true
            label.isHidden = true
            loadingIndicatorView.startAnimating()
            isHidden = false
        }
    }

    // MARK: - Actions

    @objc private func handleButtonTap() {
        delegate?.loadingRetryViewDidSelectButton(self)
    }
}
