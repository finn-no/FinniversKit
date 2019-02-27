//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol HappinessRatingViewDelegate: class {
    func happinessRatingView(_ happinessRatingView: HappinessRatingView, didSelectRating rating: HappinessRating)
}

public class HappinessRatingView: UIView {

    // MARK: - Public properties

    public weak var delegate: HappinessRatingViewDelegate?
    public var selectedRating: HappinessRating? {
        didSet {
            guard let selectedRating = selectedRating else { return }
            print(selectedRating)
            delegate?.happinessRatingView(self, didSelectRating: selectedRating)
        }
    }

    // MARK: - Private properties

    private lazy var ratingImageViews: [RatingImageView] = {
        let ratingImageViews = HappinessRating.allCases.map { RatingImageView(rating: $0) }
        ratingImageViews.forEach {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ratingImageViewTapped(_:)))
            $0.addGestureRecognizer(tapGestureRecognizer)
        }
        return ratingImageViews
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.distribution = .equalSpacing
        ratingImageViews.forEach { stackView.addArrangedSubview($0) }
        return stackView
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
        addSubview(stackView)
        stackView.fillInSuperview()
    }

    // MARK: - Overrides

    public override func layoutSubviews() {
        super.layoutSubviews()
        NSLayoutConstraint.activate(
            ratingImageViews.map { $0.widthAnchor.constraint(lessThanOrEqualToConstant: bounds.width / 6) }
        )
    }

    // MARK: - Private methods

    @objc private func ratingImageViewTapped(_ recognizer: UITapGestureRecognizer) {
        guard let ratingImageView = recognizer.view as? RatingImageView else { return }

        let animationDuration: Double
        switch selectedRating {
        case nil: animationDuration = 0.1
        case _ where selectedRating != ratingImageView.rating: animationDuration = 0.15
        default: return
        }

        let nonSelectedViews = ratingImageViews.filter { $0.rating != ratingImageView.rating }
        UIView.animate(withDuration: animationDuration, animations: {
            nonSelectedViews.forEach {
                $0.tintColor = .sardine
                $0.transform = .identity
            }
        })
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, animations: {
            ratingImageView.tintColor = .primaryBlue
            ratingImageView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        })

        if #available(iOS 10.0, *) {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }
        selectedRating = ratingImageView.rating
    }
}

// MARK: - RatingImageView

private class RatingImageView: UIImageView {

    // MARK: - Public properties

    public let rating: HappinessRating

    // MARK: - Init

    init(rating: HappinessRating) {
        self.rating = rating
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        image = rating.image
        contentMode = .scaleAspectFit
        tintColor = .primaryBlue
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
