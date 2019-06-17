//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol DisclaimerViewDelegate: AnyObject {
    func disclaimerViewDidSelectReadMoreButton(_ disclaimerView: DisclaimerView)
}

public class DisclaimerView: UIView {

    // MARK: - Public properties

    public weak var delegate: DisclaimerViewDelegate?

    // MARK: - Private properties

    private lazy var disclaimerLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var readMoreButton: Button = {
        let button = Button(style: .flat, size: .small)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(readMoreButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        addSubview(disclaimerLabel)
        addSubview(readMoreButton)

        NSLayoutConstraint.activate([
            disclaimerLabel.topAnchor.constraint(equalTo: topAnchor),
            disclaimerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            disclaimerLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            readMoreButton.topAnchor.constraint(equalTo: disclaimerLabel.bottomAnchor, constant: .mediumSpacing),
            readMoreButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            readMoreButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Private methods

    @objc private func readMoreButtonTapped(_ sender: Button) {
        delegate?.disclaimerViewDidSelectReadMoreButton(self)
    }

    // MARK: - Public methods

    public func configure(with viewModel: DisclaimerViewModel) {
        disclaimerLabel.text = viewModel.disclaimerText
        readMoreButton.setTitle(viewModel.readMoreButtonTitle, for: .normal)
    }
}
