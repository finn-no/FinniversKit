//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol CollapseViewDelegate: AnyObject {
    func collapseViewDidExpand(_ view: CollapseView)
    func collapseViewDidCollapse(_ view: CollapseView)
}

public class CollapseView: UIView {
    // MARK: Public properties

    public weak var delegate: CollapseViewDelegate?

    // MARK: Private properties

    private enum State {
        case expanded
        case collapsed
    }

    private lazy var hairlineView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .bgPrimary
        view.dropShadow(color: .black, opacity: 0.6, offset: CGSize(width: 0, height: 0.9), radius: 1.2)
        return view
    }()

    private lazy var selectorTitleView: SelectorTitleView = {
        let view = SelectorTitleView(withAutoLayout: true)
        view.updateButtonColor(.textSecondary, buttonDisabledColor: .textSecondary)
        view.delegate = self
        return view
    }()

    private lazy var contentView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .bgPrimary
        return view
    }()

    private var state: State

    private let defaultHeight: CGFloat = 32.0
    private let defaultContentViewHeight: CGFloat = 32.0

    private var heightAnchorConstraint: NSLayoutConstraint?

    // MARK: Parameters

    private var collapsedTitle: String
    private var expandedTitle: String
    private var injectedView: UIView?
    private var injectedViewHeight: CGFloat = 0.0

    // MARK: Initalizer

    public init(collapsedTitle: String, expandedTitle: String, viewToPresentInExpandedState: UIView?, heightOfView: CGFloat, withAutoLayout: Bool = false) {
        self.collapsedTitle = collapsedTitle
        self.expandedTitle = expandedTitle
        self.injectedView = viewToPresentInExpandedState
        self.injectedViewHeight = heightOfView
        self.state = .collapsed

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        backgroundColor = .bgPrimary

        selectorTitleView.title = collapsedTitle
        selectorTitleView.arrowDirection = .up

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func replacePresentedView(_ newView: UIView, heightOfView: CGFloat) {
        guard injectedView != newView else { return }

        self.injectedView?.alpha = 0
        self.injectedView?.removeFromSuperview()
        self.injectedView = newView
        self.injectedViewHeight = heightOfView

        if state == .expanded {
            addInjectedView(0.2)
        }
    }
}

// MARK: Private methods

extension CollapseView {
    private func setup() {
        contentView.addSubview(hairlineView)
        contentView.addSubview(selectorTitleView)
        addSubview(contentView)

        heightAnchorConstraint = heightAnchor.constraint(equalToConstant: defaultHeight)

        NSLayoutConstraint.activate([
            heightAnchorConstraint!,

            contentView.heightAnchor.constraint(equalToConstant: defaultContentViewHeight),
            contentView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),

            hairlineView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            hairlineView.bottomAnchor.constraint(equalTo: contentView.topAnchor),
            hairlineView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            hairlineView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            selectorTitleView.heightAnchor.constraint(equalToConstant: defaultContentViewHeight),
            selectorTitleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: .spacingS),
            selectorTitleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            selectorTitleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }

    private func animate(_ newState: State, withDuration duration: TimeInterval) {
        state = newState

        switch newState {
        case .expanded:
            selectorTitleView.title = expandedTitle
            selectorTitleView.arrowDirection = .down
            addInjectedView(duration)
            delegate?.collapseViewDidExpand(self)
        case .collapsed:
            selectorTitleView.title = collapsedTitle
            selectorTitleView.arrowDirection = .up
            removeInjectedView(duration)
            delegate?.collapseViewDidCollapse(self)
        }
    }

    private func addInjectedView(_ duration: TimeInterval) {
        if let view = injectedView {
            view.alpha = 0
            addSubview(view)

            NSLayoutConstraint.activate([
                view.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: .spacingS),
                view.heightAnchor.constraint(equalToConstant: injectedViewHeight),
                view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            ])

            UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveLinear, animations: {
                self.heightAnchorConstraint?.constant = self.defaultHeight + self.injectedViewHeight
                self.layoutIfNeeded()

                view.alpha = 1
            })
        }
    }

    private func removeInjectedView(_ duration: TimeInterval) {
        guard let view = injectedView else { return }
        view.alpha = 0

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .curveLinear, animations: {
            view.removeFromSuperview()

            self.heightAnchorConstraint?.constant = self.defaultHeight
            self.layoutIfNeeded()
        })
    }
}

// MARK: SelectorTitleViewDelegate

extension CollapseView: SelectorTitleViewDelegate {
    public func selectorTitleViewDidSelectButton(_ view: SelectorTitleView) {
        let newState = (state == .collapsed) ? State.expanded : State.collapsed
        animate(newState, withDuration: 0.2)
    }
}
