//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit
import Warp

public protocol KlimabroletViewDelegate: AnyObject {
    func klimabroletViewDidSelectReadMore(_ view: KlimabroletView)
    func klimabroletViewDidSelectAccept(_ view: KlimabroletView)
    func klimabroletViewDidSelectDecline(_ view: KlimabroletView)
    func klimabroletViewDidSelectClose(_ view: KlimabroletView)
}

public class KlimabroletView: UIView {
    // MARK: - Public properties

    public weak var delegate: KlimabroletViewDelegate?

    // MARK: - Private properties

    private var shadowAnimationDuration = 0.12
    private var contentSizeObservation: NSKeyValueObservation?

    private lazy var closeButton: UIButton = {
        let button = UIButton(withAutoLayout: true)
        button.tintColor = .background
        button.setImage(UIImage(named: .cross), for: .normal)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        button.contentEdgeInsets = UIEdgeInsets(all: 6)
        button.addTarget(self, action: #selector(handleTapOnCloseButton), for: .touchUpInside)

        return button
    }()

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView(withAutoLayout: true)
        scrollView.bounces = true
        scrollView.contentInset = UIEdgeInsets(bottom: Warp.Spacing.spacing400)
        scrollView.delegate = self
        scrollView.delaysContentTouches = false
        return scrollView
    }()

    private lazy var contentView: KlimabroletContentView = {
        let view = KlimabroletContentView(withAutoLayout: true)
        view.delegate = self
        return view
    }()

    private lazy var actionsView: KlimabroletActionsView = {
        let view = KlimabroletActionsView(withAutoLayout: true)
        view.layer.shadowOffset = .zero
        view.delegate = self
        return view
    }()

    // MARK: - Initializers

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        closeButton.layer.cornerRadius = closeButton.bounds.width / 2.0
    }

    // MARK: - Public methods

    public func configure(with viewModel: KlimabroletViewModel) {
        contentView.configure(with: viewModel)
        actionsView.configure(
            primaryButtonTitle: viewModel.acceptButtonTitle,
            secondaryButtonTitle: viewModel.declineButtonTitle
        )
    }

    // MARK: - Private methods

    private func setup() {
        backgroundColor = .background
        layer.cornerRadius = 20
        clipsToBounds = true

        scrollView.addSubview(contentView)

        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.fillInSuperview()

        addSubview(scrollView)
        addSubview(actionsView)
        addSubview(closeButton)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: topAnchor, constant: Warp.Spacing.spacing100),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Warp.Spacing.spacing100),

            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: actionsView.topAnchor),

            actionsView.leadingAnchor.constraint(equalTo: leadingAnchor),
            actionsView.trailingAnchor.constraint(equalTo: trailingAnchor),
            actionsView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        contentSizeObservation = scrollView.observe(
            \UIScrollView.contentSize, options: [.old, .new], changeHandler: contentSizeDidChange(_:change:)
        )
    }

    @objc private func handleTapOnCloseButton() {
        delegate?.klimabroletViewDidSelectClose(self)
    }

    private func contentSizeDidChange(_ scrollView: UIScrollView, change: NSKeyValueObservedChange<CGSize>) {
        guard let contentSize = change.newValue else {
            return
        }

        if scrollView.contentOffset.y + scrollView.frame.height < contentSize.height {
            actionsView.layer.shadowOpacity = 0.2
        }
    }
}

// MARK: - UIScrollViewDelegate

extension KlimabroletView: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.height < contentView.intrinsicContentSize.height {
            animateShadow(fromValue: 0.2, toValue: 0, duration: shadowAnimationDuration)
        } else {
            animateShadow(fromValue: 0, toValue: 0.2, duration: shadowAnimationDuration)
        }
    }

    func animateShadow(fromValue from: Float, toValue to: Float, duration: Double) {
        guard actionsView.layer.shadowOpacity != to else { return }
        let animation = CABasicAnimation(keyPath: "shadowOpacity")
        animation.fromValue = from
        animation.toValue = to
        animation.duration = duration
        actionsView.layer.add(animation, forKey: nil)
        actionsView.layer.shadowOpacity = to
    }
}

// MARK: - KlimabroletActionsViewDelegate

extension KlimabroletView: KlimabroletActionsViewDelegate {
    func klimabroletViewDidSelectPrimaryButton(_ view: KlimabroletActionsView) {
        delegate?.klimabroletViewDidSelectAccept(self)
    }

    func klimabroletViewDidSelectSecondaryButton(_ view: KlimabroletActionsView) {
        delegate?.klimabroletViewDidSelectDecline(self)
    }
}

// MARK: - KlimabroletContentViewDelegate

extension KlimabroletView: KlimabroletContentViewDelegate {
    func klimabroletViewDidSelectReadMore(_ view: KlimabroletContentView) {
        delegate?.klimabroletViewDidSelectReadMore(self)
    }
}
