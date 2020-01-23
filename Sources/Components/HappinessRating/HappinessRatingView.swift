//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol HappinessRatingViewDelegate: AnyObject {
    func happinessRatingView(_ happinessRatingView: HappinessRatingView, didSelectRating rating: HappinessRating)
    func happinessRatingView(_ happinessRatingView: HappinessRatingView, textFor rating: HappinessRating) -> String?
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

    private lazy var ratingViews: [RatingView] = {
        let ratingViews = HappinessRating.allCases.map { RatingView(rating: $0, delegate: self) }
        ratingViews.forEach {
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ratingViewTapped))
            $0.addGestureRecognizer(tapGestureRecognizer)
        }
        return ratingViews
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.distribution = .equalSpacing
        stackView.alignment = .top
        ratingViews.forEach { stackView.addArrangedSubview($0) }
        stackView.addGestureRecognizer(panRecognizer)
        return stackView
    }()

    private lazy var panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureHandler(_:)))

    // MARK: - Init

    public init(frame: CGRect = .zero, delegate: HappinessRatingViewDelegate?) {
        super.init(frame: frame)
        self.delegate = delegate
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
            ratingViews.map { $0.widthAnchor.constraint(lessThanOrEqualToConstant: bounds.width / 6) }
        )
    }

    // MARK: - Private methods

    @objc private func ratingViewTapped(_ recognizer: UITapGestureRecognizer) {
        guard let ratingImageView = recognizer.view as? RatingView else { return }
        setSelectedRatingView(ratingImageView)
    }

    @objc private func panGestureHandler(_ recognizer: UIPanGestureRecognizer) {
        let touchedView = recognizer.view
        var touchLocation = recognizer.location(in: touchedView)
        touchLocation.y = bounds.height / 2
        guard let ratingView = touchedView?.hitTest(touchLocation, with: nil) as? RatingView else { return }
        setSelectedRatingView(ratingView)
    }

    private func setSelectedRatingView(_ ratingView: RatingView) {
        let animationDuration: Double
        switch selectedRating {
        case nil: animationDuration = 0.1
        case _ where selectedRating != ratingView.rating: animationDuration = 0.15
        default: return
        }

        let nonSelectedViews = ratingViews.filter { $0.rating != ratingView.rating }
        UIView.animate(withDuration: animationDuration, animations: {
            ratingView.tintColor = .btnPrimary
            nonSelectedViews.forEach {
                $0.tintColor = UIColor.btnPrimary.withAlphaComponent(0.6)
                $0.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
        })
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, animations: {
            ratingView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        })

        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        selectedRating = ratingView.rating
    }
}

extension HappinessRatingView: RatingViewDelegate {
    func ratingViewText(for rating: HappinessRating) -> String? {
        switch rating {
        case .angry:
            return delegate?.happinessRatingView(self, textFor: rating)
        case .dissatisfied:
            return delegate?.happinessRatingView(self, textFor: rating)
        case .neutral:
            return delegate?.happinessRatingView(self, textFor: rating)
        case .happy:
            return delegate?.happinessRatingView(self, textFor: rating)
        case .love:
            return delegate?.happinessRatingView(self, textFor: rating)
        }
    }
}

// MARK: - RatingView

private protocol RatingViewDelegate: AnyObject {
    func ratingViewText(for rating: HappinessRating) -> String?
}

private class RatingView: UIView {
    // MARK: - Internal properties

    let rating: HappinessRating
    weak var delegate: RatingViewDelegate?

    private lazy var container: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = .mediumSpacing
        stackView.isUserInteractionEnabled = false
        return stackView
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(withAutoLayout: true)
        imageView.image = rating.image
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .btnPrimary
        imageView.isUserInteractionEnabled = false

        return imageView
    }()

    private lazy var label: UILabel = {
        let label = Label(style: .detail, withAutoLayout: true)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.isUserInteractionEnabled = false
        return label
    }()

    // MARK: - Init

    init(rating: HappinessRating, delegate: RatingViewDelegate? = nil) {
        self.rating = rating
        self.delegate = delegate

        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false

        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        container.addArrangedSubview(imageView)
        addSubview(container)
        container.fillInSuperview()
        setupLabel()
    }

    func setupLabel() {
        guard let text = delegate?.ratingViewText(for: rating) else { return }
        label.text = text
        container.addArrangedSubview(label)
    }
}
