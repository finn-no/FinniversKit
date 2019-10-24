//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import UIKit

public protocol ReviewButtonViewDelegate: AnyObject {
    func reviewButtonView(_ reviewButtonView: ReviewButtonView, giveReviewWasTapped startReview: Bool)
}

public final class ReviewButtonView: UIView {
    // MARK: - Public

    public weak var delegate: ReviewButtonViewDelegate?
    public var buttonText: String = "" {
        didSet {
            reviewButtonControl.text = buttonText
            accessibilityLabel = buttonText
        }
    }

    // MARK: - Private

    private let height: CGFloat = 64

    private lazy var hairlineSeperator: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .tableViewSeparator
        return view
    }()

    private lazy var reviewButtonControl: ReviewButtonControl = {
        let control = ReviewButtonControl()
        control.delegate = self
        return control
    }()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Overrides

    public override func didMoveToSuperview() {
        guard let superView = superview else { return }

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: self.height),
            widthAnchor.constraint(equalTo: superView.widthAnchor),
            bottomAnchor.constraint(equalTo: superView.bottomAnchor)
        ])
    }

    // MARK: - Public methods

    public func show() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform.identity
            self.alpha = 1
        }
    }

    public func hide() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(translationX: 0, y: self.height * 2)
            self.alpha = 0
        }
    }

    // MARK: - Private methods

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .bgPrimary

        addSubview(hairlineSeperator)
        addSubview(reviewButtonControl)

        NSLayoutConstraint.activate([
            hairlineSeperator.topAnchor.constraint(equalTo: topAnchor),
            hairlineSeperator.leadingAnchor.constraint(equalTo: leadingAnchor),
            hairlineSeperator.trailingAnchor.constraint(equalTo: trailingAnchor),
            hairlineSeperator.heightAnchor.constraint(equalToConstant: 1),

            reviewButtonControl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumSpacing),
            reviewButtonControl.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumSpacing),
            reviewButtonControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumSpacing),
            reviewButtonControl.heightAnchor.constraint(equalToConstant: 48),
        ])
    }
}

extension ReviewButtonView: ReviewButtonControlDelegate {
    public func reviewButtonControl(_ reviewButtonControl: ReviewButtonControl, giveReviewWasTapped startReview: Bool) {
        delegate?.reviewButtonView(self, giveReviewWasTapped: startReview)
    }
}
