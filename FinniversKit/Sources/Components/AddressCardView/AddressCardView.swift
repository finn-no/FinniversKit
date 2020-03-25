//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol AddressCardViewDelegate: AnyObject {
    func addressCardViewDidSelectCopyButton(_ addressCardView: AddressCardView)
    func addressCardViewDidSelectGetDirectionsButton(_ addressCardView: AddressCardView, sender: UIView)
}

public final class AddressCardView: UIView {
    public weak var delegate: AddressCardViewDelegate?

    // MARK: - Private properties

    private lazy var titleLabel: Label = {
        let label = Label(style: .title3Strong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var copyButton: Button = {
        let button = Button(style: .default, size: .small)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.addTarget(self, action: #selector(copyAction), for: .touchUpInside)
        return button
    }()

    private lazy var getDirectionsButton: Button = {
        let button = Button(style: .callToAction)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(getDirectionsAction), for: .touchUpInside)
        return button
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    // MARK: - Setup

    public func configure(with model: AddressCardViewModel) {
        titleLabel.text = model.title
        subtitleLabel.text = model.subtitle
        copyButton.setTitle(model.copyButtonTitle, for: .normal)
        getDirectionsButton.setTitle(model.getDirectionsButtonTitle, for: .normal)
    }

    private func setup() {
        backgroundColor = .bgPrimary

        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(copyButton)
        addSubview(getDirectionsButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: .spacingM),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            titleLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: copyButton.leadingAnchor,
                constant: -.spacingM
            ),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingXS),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: copyButton.leadingAnchor,
                constant: -.spacingM
            ),

            copyButton.centerYAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .spacingXXS),
            copyButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),

            getDirectionsButton.topAnchor.constraint(
                equalTo: subtitleLabel.bottomAnchor,
                constant: .spacingM + .spacingS
            ),
            getDirectionsButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.spacingM),
            getDirectionsButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .spacingM),
            getDirectionsButton.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -.spacingM + -.spacingS)
        ])
    }

    // MARK: - Actions

    @objc private func getDirectionsAction() {
        delegate?.addressCardViewDidSelectGetDirectionsButton(self, sender: getDirectionsButton)
    }

    @objc private func copyAction() {
        delegate?.addressCardViewDidSelectCopyButton(self)
    }
}
