//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol HappinessRatingViewDelegate: AnyObject {
    func happinessRatingView(_ happinessRatingView: HappinessRatingView, didSelectRating rating: HappinessRating)
    func happinessRatingView(_ happinessRatingView: HappinessRatingView, textFor: HappinessRating) -> String?
}

extension HappinessRatingViewDelegate {
    func happinessRatingView(_ happinessRatingView: HappinessRatingView, textFor: HappinessRating) -> String? { return nil }
}

public class HappinessRatingView: UIView {

    // MARK: - Public properties

    public weak var delegate: HappinessRatingViewDelegate?

    public private(set) var selectedRating: HappinessRating? {
        didSet {
            guard let selectedRating = selectedRating else { return }
            delegate?.happinessRatingView(self, didSelectRating: selectedRating)
        }
    }

    // MARK: - Private properties

    private lazy var ratingImageViews: [RatingImageView] = {
        let ratingImageViews = HappinessRating.allCases.map { RatingImageView(rating: $0, showTextLabel: true, delegate: self) }
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
        stackView.addGestureRecognizer(panRecognizer)
        return stackView
    }()

    private lazy var panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(_:)))

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
        setSelectedRatingView(ratingImageView)
    }

    @objc private func panGestureHandler(_ recognizer: UIPanGestureRecognizer) {
        let touchedView = recognizer.view
        var touchLocation = recognizer.location(in: touchedView)
        touchLocation.y = bounds.height / 2
        guard let ratingImageView = touchedView?.hitTest(touchLocation, with: nil) as? RatingImageView else { return }
        setSelectedRatingView(ratingImageView)
    }

    private func setSelectedRatingView(_ ratingImageView: RatingImageView) {
        let animationDuration: Double
        switch selectedRating {
        case nil: animationDuration = 0.1
        case _ where selectedRating != ratingImageView.rating: animationDuration = 0.15
        default: return
        }

        let nonSelectedViews = ratingImageViews.filter { $0.rating != ratingImageView.rating }
        UIView.animate(withDuration: animationDuration, animations: {
            ratingImageView.tintColor = .primaryBlue
            nonSelectedViews.forEach {
                $0.tintColor = UIColor.primaryBlue.withAlphaComponent(0.6)
                $0.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
        })
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, animations: {
            ratingImageView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        })

        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        selectedRating = ratingImageView.rating
    }
}

extension HappinessRatingView: RatingImageViewDelegate {
    func ratingImageViewText(for rating: HappinessRating) -> String? {
        switch rating {
        case .angry:
            return "Veldig irriterende"
        case .dissatisfied:
            return nil
        case .neutral:
            return "Nøytral"
        case .happy:
            return nil
        case .love:
            return "Veldig nyttig"
        }
    }
}

// MARK: - RatingImageView

protocol RatingImageViewDelegate: AnyObject {
    func ratingImageViewText(for rating: HappinessRating) -> String?
}

private class RatingImageView: UIImageView {

    // MARK: - Public properties

    public let rating: HappinessRating
    public let showTextLabel: Bool
    public weak var delegate: RatingImageViewDelegate?

    // MARK: - Init

    init(rating: HappinessRating, showTextLabel: Bool = false, delegate: RatingImageViewDelegate? = nil) {
        self.rating = rating
        self.showTextLabel = showTextLabel
        self.delegate = delegate

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        image = rating.image
        contentMode = .scaleAspectFit
        tintColor = .primaryBlue

        setup()
    }

    func setup() {
        if showTextLabel {
            guard let text = delegate?.ratingImageViewText(for: rating) else { return }
            let textLabel = rating.textLabel(text: text)
            addSubview(textLabel)

            let paddingToFitTwoLongWords: CGFloat = 3 // e.g: Veldig irriterende

            NSLayoutConstraint.activate([
                textLabel.topAnchor.constraint(equalTo: bottomAnchor, constant: .smallSpacing),
                textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                textLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: paddingToFitTwoLongWords)
            ])
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
