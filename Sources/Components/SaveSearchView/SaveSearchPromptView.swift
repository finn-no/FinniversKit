//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

// MARK: - SaveSearchPromptViewDelegate

public protocol SaveSearchPromptViewDelegate: AnyObject {
    func saveSearchPromptView(_ saveSearchPromptView: SaveSearchPromptView, didAcceptSaveSearch: Bool)
}

// MARK: - SaveSearchPromptView

public class SaveSearchPromptView: UIView {

    // MARK: - Public properties

    public weak var delegate: SaveSearchPromptViewDelegate?

    // MARK: - Private properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = .textPrimary
        label.textAlignment = .center
        label.font = .captionStrong
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var positiveButton: UIButton = {
        let button = Button(style: .utility, size: .small)
        button.addTarget(self, action: #selector(positiveButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var dismissButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setImage(UIImage(named: .remove), for: .normal)
        button.tintColor = .stone
        button.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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

    private func setup() {
        backgroundColor = .marble

        addSubview(titleLabel)
        addSubview(positiveButton)
        addSubview(dismissButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .mediumSpacing*3),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),

            positiveButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .mediumLargeSpacing),
            positiveButton.centerXAnchor.constraint(equalTo: centerXAnchor),

            dismissButton.topAnchor.constraint(equalTo: topAnchor, constant: .smallSpacing),
            dismissButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.smallSpacing),
            dismissButton.widthAnchor.constraint(equalToConstant: 28),
            dismissButton.heightAnchor.constraint(equalToConstant: 28),
        ])
    }

    // MARK: - Public methods

    public func configure(title: String, positiveButtonTitle: String) {
        titleLabel.text = title
        positiveButton.setTitle(positiveButtonTitle, for: .normal)
    }

    // MARK: - Private methods

    @objc private func positiveButtonTapped() {
        delegate?.saveSearchPromptView(self, didAcceptSaveSearch: true)
    }

    @objc private func dismissButtonTapped() {
        delegate?.saveSearchPromptView(self, didAcceptSaveSearch: false)
    }
}
