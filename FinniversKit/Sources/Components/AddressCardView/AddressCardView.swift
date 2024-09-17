//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import Warp

public protocol AddressCardViewDelegate: AnyObject {
    func addressCardViewDidSelectCopyButton(_ addressCardView: AddressCardView)
    func addressCardViewDidSelectGetDirectionsButton(_ addressCardView: AddressCardView, sender: UIView)
}

public final class AddressCardView: UIView {

    // MARK: - Public properties

    public weak var delegate: AddressCardViewDelegate?

    // MARK: - Private properties

    private lazy var addressStackView = UIStackView(axis: .vertical, spacing: Warp.Spacing.spacing50, withAutoLayout: true)
    private lazy var contentStackView = UIStackView(axis: .vertical, spacing: Warp.Spacing.spacing300, withAutoLayout: true)
    private lazy var titleLabel = Label(style: .title3, withAutoLayout: true)
    private lazy var subtitleLabel = Label(style: .bodyStrong, withAutoLayout: true)

    private lazy var topStackView: UIStackView = {
        let view = UIStackView(axis: .horizontal, spacing: Warp.Spacing.spacing200, withAutoLayout: true)
        view.alignment = .center
        view.distribution = .equalSpacing
        return view
    }()

    private lazy var copyButton: Button = {
        let button = Button(style: .default, size: .small, withAutoLayout: true)
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        button.addTarget(self, action: #selector(copyAction), for: .touchUpInside)
        return button
    }()

    private lazy var getDirectionsButton: Button = {
        let button = Button(style: .callToAction, withAutoLayout: true)
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

        if let getDirectionsButtonTitle = model.getDirectionsButtonTitle {
            getDirectionsButton.setTitle(getDirectionsButtonTitle, for: .normal)
            getDirectionsButton.isHidden = false
        } else {
            getDirectionsButton.isHidden = true
        }
    }

    private func setup() {
        backgroundColor = .background

        addressStackView.addArrangedSubviews([titleLabel, subtitleLabel])
        topStackView.addArrangedSubviews([addressStackView, copyButton])
        contentStackView.addArrangedSubviews([topStackView, getDirectionsButton])

        addSubview(contentStackView)
        contentStackView.fillInSuperview(insets: UIEdgeInsets(top: Warp.Spacing.spacing200, leading: Warp.Spacing.spacing200, bottom: -Warp.Spacing.spacing300, trailing: -Warp.Spacing.spacing200))
    }

    // MARK: - Actions

    @objc private func getDirectionsAction() {
        delegate?.addressCardViewDidSelectGetDirectionsButton(self, sender: getDirectionsButton)
    }

    @objc private func copyAction() {
        delegate?.addressCardViewDidSelectCopyButton(self)
    }
}
