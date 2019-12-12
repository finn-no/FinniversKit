//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol CollapseViewDelegate: AnyObject {
    func willExpand(_ view: CollapseView)
    func willCollapse(_ view: CollapseView)
    func showViewInExpandedState(_ view: CollapseView) -> UIView?
}

public class CollapseView: UIView {
    // MARK: Public properties

    public weak var delegate: CollapseViewDelegate?

    // MARK: Private properties

    private enum State {
        case expanded
        case collapsed
    }

    private var state: State

    private var collapsedTitle: String
    private var expandedTitle: String
    private var contentHeight: CGFloat =  32.0

    private lazy var hairlineView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .bgPrimary
        view.dropShadow(color: .black, opacity: 0.8, offset: CGSize(width: 0, height: 0.9), radius: 1.2)
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

    private var delegateView: UIView?
    private lazy var contentViewCollapseTransformation = CGAffineTransform(translationX: 0, y: contentHeight - 24)

    // MARK: Initalizer

    public init(collapsedTitle: String, expandedTitle: String, contentViewHeight: CGFloat, withAutoLayout: Bool = false) {
        self.collapsedTitle = collapsedTitle
        self.expandedTitle = expandedTitle
        self.contentHeight += contentViewHeight
        self.state = .collapsed

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = !withAutoLayout
        backgroundColor = .bgPrimary

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private methods

extension CollapseView {
    private func setup() {
        transition(to: .collapsed)

        contentView.addSubview(hairlineView)
        contentView.addSubview(selectorTitleView)
        addSubview(contentView)

        NSLayoutConstraint.activate([
            hairlineView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            hairlineView.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            hairlineView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            hairlineView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),

            selectorTitleView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            selectorTitleView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            selectorTitleView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: .mediumSpacing),

            contentView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            contentView.heightAnchor.constraint(equalToConstant: contentHeight),

            heightAnchor.constraint(greaterThanOrEqualToConstant: contentHeight)
        ])

        contentView.transform = contentViewCollapseTransformation
    }

    private func transition(to newState: State) {
        state = newState

        switch newState {
        case .expanded:
            selectorTitleView.title = expandedTitle
            selectorTitleView.arrowDirection = .down
            delegate?.willExpand(self)
        case .collapsed:
            selectorTitleView.title = collapsedTitle
            selectorTitleView.arrowDirection = .up
            delegate?.willCollapse(self)
        }

        animate(to: newState, withDuration: 0.2)
    }

    private func animate(to newState: State, withDuration duration: TimeInterval) {
        switch newState {
        case .expanded:
            UIView.animate(withDuration: duration, animations: {
                self.contentView.transform = .identity
                self.addDelegateView(duration)
            })
        case .collapsed:
            UIView.animate(withDuration: duration, animations: {
                self.contentView.transform = self.contentViewCollapseTransformation
                self.removeDelegateView(duration)
            })
        }
    }

    private func addDelegateView(_ duration: TimeInterval) {
        guard contentHeight > 32 else {
            print("The provided value to the parameter contentViewHeight has to be greater than 0 in order to properly render the delegate view.")
            return
        }

        guard let viewToPresent = delegate?.showViewInExpandedState(self) else { return }
        delegateView = viewToPresent

        if let view = delegateView {
            view.alpha = 0

            contentView.addSubview(view)

            NSLayoutConstraint.activate([
                view.leadingAnchor.constraint(equalTo: selectorTitleView.leadingAnchor),
                view.trailingAnchor.constraint(equalTo: selectorTitleView.trailingAnchor),

                view.topAnchor.constraint(equalTo: selectorTitleView.bottomAnchor, constant: .mediumSpacing),
                view.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),

                view.heightAnchor.constraint(lessThanOrEqualTo: contentView.heightAnchor),
            ])

            UIView.animate(withDuration: duration, animations: {
                view.alpha = 1
            })
        }
    }

    private func removeDelegateView(_ duration: TimeInterval) {
        guard let view = delegateView else { return }
        UIView.animate(withDuration: duration, animations: {
            view.alpha = 0
        }, completion: { _ in
            view.removeFromSuperview()
        })
    }
}

// MARK: SelectorTitleViewDelegate

extension CollapseView: SelectorTitleViewDelegate {
    public func selectorTitleViewDidSelectButton(_ view: SelectorTitleView) {
        let newState = (state == .collapsed) ? State.expanded : State.collapsed
        transition(to: newState)
    }
}
