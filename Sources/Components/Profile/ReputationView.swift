//
// Copyright (c) 2019 FINN AS. All rights reserved.
//

import UIKit

// MARK: - View Models

public enum ReputationBreakdownMode {
    case compact
    case collapsedByDefault
    case alwaysExpanded
}

public protocol ReputationViewModel {
    var title: String { get }
    var subtitle: String { get }

    /// Expected to be in the range [0 ... 1]
    var score: Float { get }

    var categoryBreakdowns: [ReputationBreakdownModel] { get }
    var breakdownMode: ReputationBreakdownMode { get }
}

public protocol ReputationBreakdownModel {
    var category: ReputationBreakdownCategory { get }
    var title: String { get }
}

public enum ReputationBreakdownCategory {
    case communication
    case payment
    case transaction
    case description

    fileprivate var icon: UIImage {
        switch self {
        case .communication:
            return UIImage(named: .speechbubbleSmiley)
        case .payment:
            return UIImage(named: .creditcard)
        case .transaction:
            return UIImage(named: .handshake)
        case .description:
            return UIImage(named: .document)
        }
    }
}

// MARK: - ProfileSummaryView

public protocol ReputationViewDelegate: AnyObject {
    func reputationViewWasTapped(_ reputationView: ReputationView)
}

public class ReputationView: UIView {

    // MARK: - UI properties

    private let reviewScoreSize: CGFloat = 40.0

    private lazy var scoreBackgroundView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = .primaryBlue
        view.layer.cornerRadius = reviewScoreSize / 2.0
        return view
    }()

    private lazy var scoreLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = formattedScore
        label.textColor = .milk
        return label
    }()

    private lazy var titleLabel: Label = {
        let label = Label(style: .bodyStrong)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = viewModel.title
        return label
    }()

    private lazy var subtitleLabel: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = viewModel.subtitle
        label.textColor = .primaryBlue
        return label
    }()

    private lazy var collapseWrapper: UIView = {
        let view = UIView(withAutoLayout: true)

        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(collapseButtonTapped))
        view.addGestureRecognizer(gestureRecognizer)

        return view
    }()

    private lazy var collapseImage: UIImageView = {
        let view = UIImageView(image: UIImage(named: .arrowDown))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .stone
        return view
    }()

    private lazy var breakdownWrapper: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = .mediumLargeSpacing
        view.distribution = .equalSpacing
        return view
    }()

    private lazy var showBreakdownConstraint = breakdownWrapper.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -.mediumLargeSpacing)

    // MARK: - Private properties

    private var isCollapsed: Bool

    // MARK: - Public properties

    public let viewModel: ReputationViewModel

    // MARK: - Private properties

    private var formattedScore: String {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.maximumSignificantDigits = 2
        nf.minimumSignificantDigits = 2
        return nf.string(from: NSNumber(value: viewModel.score * 10)) ?? "\(viewModel.score)"
    }

    // MARK: - Setup

    required init?(coder aDecoder: NSCoder) {
        fatalError("\(#function) not implemented")
    }

    public init(viewModel: ReputationViewModel) {
        self.viewModel = viewModel
        self.isCollapsed = viewModel.breakdownMode != .alwaysExpanded
        super.init(frame: .zero)
        setup()
        addBreakdownViews()
    }

    private func setup() {
        layer.cornerRadius = 8
        backgroundColor = .ice
        clipsToBounds = true

        addSubview(scoreBackgroundView)
        scoreBackgroundView.addSubview(scoreLabel)
        addSubview(titleLabel)
        addSubview(subtitleLabel)

        addSubview(collapseWrapper)
        collapseWrapper.addSubview(collapseImage)

        addSubview(breakdownWrapper)

        if viewModel.categoryBreakdowns.isEmpty {
            collapseWrapper.isHidden = true
            showBreakdownConstraint.isActive = false
        } else {
            collapseWrapper.isHidden = viewModel.breakdownMode != .collapsedByDefault
            showBreakdownConstraint.isActive = viewModel.breakdownMode == .alwaysExpanded
        }

        NSLayoutConstraint.activate([
            scoreBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            scoreBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            scoreBackgroundView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -.mediumLargeSpacing),
            scoreBackgroundView.widthAnchor.constraint(equalToConstant: reviewScoreSize),
            scoreBackgroundView.heightAnchor.constraint(equalToConstant: reviewScoreSize),

            scoreLabel.centerXAnchor.constraint(equalTo: scoreBackgroundView.centerXAnchor),
            scoreLabel.centerYAnchor.constraint(equalTo: scoreBackgroundView.centerYAnchor),

            titleLabel.leadingAnchor.constraint(equalTo: scoreBackgroundView.trailingAnchor, constant: .mediumSpacing),
            titleLabel.topAnchor.constraint(equalTo: scoreBackgroundView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: collapseWrapper.leadingAnchor, constant: -.mediumLargeSpacing),

            subtitleLabel.leadingAnchor.constraint(equalTo: scoreBackgroundView.trailingAnchor, constant: .mediumSpacing),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: .verySmallSpacing),
            subtitleLabel.trailingAnchor.constraint(equalTo: collapseWrapper.leadingAnchor, constant: -.mediumLargeSpacing),

            collapseWrapper.topAnchor.constraint(equalTo: topAnchor, constant: .mediumLargeSpacing),
            collapseWrapper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
            collapseWrapper.widthAnchor.constraint(equalToConstant: reviewScoreSize),
            collapseWrapper.heightAnchor.constraint(equalToConstant: reviewScoreSize),

            collapseImage.centerXAnchor.constraint(equalTo: collapseWrapper.centerXAnchor),
            collapseImage.centerYAnchor.constraint(equalTo: collapseWrapper.centerYAnchor),

            breakdownWrapper.leadingAnchor.constraint(equalTo: leadingAnchor, constant: .mediumLargeSpacing),
            breakdownWrapper.topAnchor.constraint(greaterThanOrEqualTo: scoreBackgroundView.bottomAnchor, constant: .mediumLargeSpacing),
            breakdownWrapper.topAnchor.constraint(greaterThanOrEqualTo: subtitleLabel.bottomAnchor, constant: .mediumLargeSpacing),
            breakdownWrapper.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -.mediumLargeSpacing),
        ])
    }
}

// MARK: - Breakdown & Collapse Handling

extension ReputationView {
    @objc private func collapseButtonTapped() {
        isCollapsed.toggle()

        let newImage = UIImage(named: isCollapsed ? .arrowDown : .arrowUp)
        UIView.transition(with: collapseImage, duration: 0.1, options: [.transitionCrossDissolve], animations: {
            self.collapseImage.image = newImage
        })

        showBreakdownConstraint.isActive = !isCollapsed
        UIView.animate(withDuration: 0.3, animations: {
            self.superview?.layoutIfNeeded()
        })
    }

    private func addBreakdownViews() {
        viewModel.categoryBreakdowns.forEach { model in
            let view = breakdownView(for: model)
            breakdownWrapper.addArrangedSubview(view)
        }
    }

    private func breakdownView(for model: ReputationBreakdownModel) -> UIView {
        let root = UIView(withAutoLayout: true)

        let imageWrapper = UIView(withAutoLayout: true)
        root.addSubview(imageWrapper)

        let imageView = UIImageView(image: model.category.icon)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .stone
        imageView.contentMode = .scaleAspectFit
        imageWrapper.addSubview(imageView)

        let label = Label(style: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = model.title
        root.addSubview(label)

        NSLayoutConstraint.activate([
            imageWrapper.leadingAnchor.constraint(equalTo: root.leadingAnchor),
            imageWrapper.topAnchor.constraint(greaterThanOrEqualTo: root.topAnchor),
            imageWrapper.bottomAnchor.constraint(lessThanOrEqualTo: root.bottomAnchor),
            imageWrapper.centerYAnchor.constraint(equalTo: root.centerYAnchor),
            imageWrapper.widthAnchor.constraint(equalToConstant: reviewScoreSize),

            imageView.widthAnchor.constraint(equalToConstant: 24),
            imageView.heightAnchor.constraint(equalToConstant: 24),
            imageView.topAnchor.constraint(equalTo: imageWrapper.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageWrapper.bottomAnchor),

            imageView.centerYAnchor.constraint(equalTo: imageWrapper.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: imageWrapper.centerXAnchor),

            label.leadingAnchor.constraint(equalTo: imageWrapper.trailingAnchor, constant: .mediumSpacing),
            label.topAnchor.constraint(equalTo: root.topAnchor),
            label.bottomAnchor.constraint(equalTo: root.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: root.trailingAnchor, constant: -.mediumSpacing),
        ])

        return root
    }
}
